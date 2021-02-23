//
//  iTunesSearchViewInput.swift
//  CTest3
//
//  Created by Markim Shaw on 2/23/21.
//

import Combine
import Foundation

protocol iTunesSearchViewInput {
  
  var onAppear: AnyPublisher<Void, Never> { get set }
  
  var onSearch: AnyPublisher<String, Never> { get set }
  
  var onLiveSearch: AnyPublisher<String, Never> { get set }
  
  var onArtistSelection: AnyPublisher<IndexPath, Never> { get set }
  
}
