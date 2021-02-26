//
//  iTunesSearchViewModel.swift
//  CTest3
//
//  Created by Markim Shaw on 2/23/21.
//

import Combine
import Foundation

struct Throwaway: Decodable {
  var name: String
}

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
      .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
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
        return .results(artists: artists)
      }
      .eraseToAnyPublisher()
    
    let searchPublishers = Publishers.Merge(emptySearch, onSearch).eraseToAnyPublisher()
        
    return Publishers.MergeMany(onAppear, searchPublishersce).eraseToAnyPublisher()
  }
}

enum AError: Error {
  case no
}
