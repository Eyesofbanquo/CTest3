//
//  iTunesSearchViewInput.swift
//  CTest3
//
//  Created by Markim Shaw on 2/23/21.
//

import Combine
import Foundation

struct iTunesSearchViewInput {
  
  var onAppear: AnyPublisher<Void, Never>
  
  var onSearch: AnyPublisher<String, Never>
  
  var onLiveSearch: AnyPublisher<String, Never>
  
  var onArtistSelection: AnyPublisher<IndexPath, Never> 
  
}
