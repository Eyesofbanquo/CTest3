//
//  iTunesSearchViewModel.swift
//  CTest3
//
//  Created by Markim Shaw on 2/23/21.
//

import Combine
import Foundation

final class iTunesSearchViewModel: iTunesSearchTransformable {
  
  private var network: Network
  private var dateFormatter: UTCFormatter
    
  init(network: Network = Network(), dateFormatter: UTCFormatter = UTCFormatter()) {
    self.network = network
    self.dateFormatter = dateFormatter
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
      .map { [weak self] decodedResponse -> iTunesSearchState in
        let artists = decodedResponse.results
        let artistsWithReadableDate = artists.map { oldArtist -> Artist in
          var newArtist = oldArtist
                    
          let dateObject = self?.dateFormatter.convertToDate(from: newArtist.releaseDate)
          let dateString = self?.dateFormatter.convertToString(from: dateObject)
          newArtist.releaseDate = dateString
          return newArtist
        }
        
        return .results(artists: artistsWithReadableDate)
      }
      .eraseToAnyPublisher()
    
    let searchPublishers = Publishers.Merge(emptySearch, onSearch).eraseToAnyPublisher()
        
    return Publishers.MergeMany(onAppear, searchPublishers).eraseToAnyPublisher()
  }
}
