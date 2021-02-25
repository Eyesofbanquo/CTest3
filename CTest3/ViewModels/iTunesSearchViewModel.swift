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
    
    let onAppear = input.onAppear.map { _ -> iTunesSearchState in
      return .idle
    }.receive(on: RunLoop.main).eraseToAnyPublisher()
    
    let onSearch = input.onSearch
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
      .map { decodedResponse -> iTunesSearchState in
        let artists = decodedResponse.results
        return .results(artists: artists)
      }
      .replaceError(with: .error(error: NSError()))
      .eraseToAnyPublisher()
        
    return Publishers.MergeMany(onAppear, onSearch).eraseToAnyPublisher()
  }
}
