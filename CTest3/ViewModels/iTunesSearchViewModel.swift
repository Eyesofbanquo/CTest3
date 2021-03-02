//
//  iTunesSearchViewModel.swift
//  CTest3
//
//  Created by Markim Shaw on 2/23/21.
//

import Combine
import Foundation


let dateFormatterFromUTC: DateFormatter = {
  let dateFormatterFromUTC = DateFormatter()
  dateFormatterFromUTC.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
  dateFormatterFromUTC.timeZone = NSTimeZone(name: "UTC") as TimeZone?
  return dateFormatterFromUTC
}()


let dateFormatterReadable: DateFormatter = {
  let dateFormatterReadable = DateFormatter()
  dateFormatterReadable.dateFormat = "EEE, MMM d, yyyy - h:mm a"
  dateFormatterReadable.timeZone = NSTimeZone.local
  return dateFormatterReadable
}()

final class iTunesSearchViewModel: iTunesSearchTransformable {
  
  private var network: Network
    
  init(network: Network = Network()) {
    self.network = network
  }
  
  func transform(input: iTunesSearchViewInput) -> ITunesSearchViewOutput {
    
    let onAppear = input
      .onAppear
      .receive(on: RunLoop.main)
      .map { _ -> iTunesSearchState in
      return .idle
    }
      .receive(on: RunLoop.main).eraseToAnyPublisher()
    
    let emptySearch = input
      .onSearch
      .filter { $0.isEmpty }
      .receive(on: RunLoop.main)
      .map { _ -> iTunesSearchState in
        return .results(artists: [])
      }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
    
    let onSearch = input
      .onSearch
      .filter { value in
        return !value.isEmpty
      }
      .debounce(for: .seconds(0.2), scheduler: RunLoop.main)
      .compactMap { [weak self] value -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>? in
        return self?.network.request(forArtist: value)
      }
      .switchToLatest()
      
      .tryMap { element -> Data in
        guard let httpResponse = element.response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
          throw URLError(.badServerResponse)
        }
        return element.data
      }
      
      .receive(on: DispatchQueue.main)
      .decode(type: ArtistResult.self, decoder: JSONDecoder())
      .replaceError(with: ArtistResult(resultCount: 0, results: []))
      .map { decodedResponse -> iTunesSearchState in
        let artists = decodedResponse.results
        let artistsWithReadableDate = artists.map { oldArtist -> Artist in
          var newArtist = oldArtist
          
          guard let dateString = newArtist.releaseDate, let date = dateFormatterFromUTC.date(from: dateString) else { return oldArtist }
          
          let readableDate = dateFormatterReadable.string(from: date)
          newArtist.releaseDate = readableDate
          return newArtist
        }
        
        print(artistsWithReadableDate.map { $0.releaseDate })
        return .results(artists: artistsWithReadableDate)
      }
      .eraseToAnyPublisher()
    
    let searchPublishers = Publishers.Merge(emptySearch, onSearch).eraseToAnyPublisher()
        
    return Publishers.MergeMany(onAppear, searchPublishers).eraseToAnyPublisher()
  }
}
