//
//  Network.swift
//  CTest3
//
//  Created by Markim Shaw on 2/25/21.
//

import Combine
import Foundation

class Network {
  typealias NetworkResponseType = AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
  
  let session: URLSession
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
  func request(forArtist artistName: String) -> NetworkResponseType? {
    
    var components = URLComponents()
    components.scheme = "https"
    components.host = "itunes.apple.com"
    components.path = "/search"
    components.queryItems = [URLQueryItem(name: "term", value: artistName)]
    
    guard let url = components.url else {
      return nil
    }
    
    let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
    
    return session.dataTaskPublisher(for: request).eraseToAnyPublisher()
    
  }
}
