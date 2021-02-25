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
  
  lazy var network: Network = Network()
  
  func transform(input: iTunesSearchViewInput) -> ITunesSearchViewOutput {
    
    let network = Network()
    
    let onAppear = input.onAppear.map { _ -> iTunesSearchState in
      return .idle
    }.eraseToAnyPublisher()
    
    let onSearch = input.onSearch
      .compactMap { value -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>? in
      return network.request(forArtist: value)
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
      .decode(type: Throwaway.self, decoder: JSONDecoder())
      .map { t -> iTunesSearchState in
        return .idle
      }
      .replaceError(with: .error(error: NSError()))
      .eraseToAnyPublisher()
        
    return Publishers.MergeMany(onAppear, onSearch).eraseToAnyPublisher()
  }
}
