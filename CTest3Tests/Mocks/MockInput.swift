//
//  MockInput.swift
//  CTest3Tests
//
//  Created by Markim Shaw on 2/25/21.
//

import Combine
import Foundation

@testable import CTest3

struct MockInput {
  var onAppear: AnyPublisher<Void, Never>
  
  var onSearch: AnyPublisher<String, Never>
  
  var onLiveSearch: AnyPublisher<String, Never>
  
  var onArtistSelection: AnyPublisher<IndexPath, Never>
  
  
}

extension iTunesSearchViewInput {
  static var OnAppear = PassthroughSubject<Void, Never>()
  static var OnSearch = PassthroughSubject<String, Never>()
  static var OnLiveSearch = PassthroughSubject<String, Never>()
  static var OnArtistSelection = PassthroughSubject<IndexPath, Never>()
  static var standard: iTunesSearchViewInput = iTunesSearchViewInput(onAppear: Self.OnAppear.eraseToAnyPublisher(),
                                             onSearch: Self.OnSearch.eraseToAnyPublisher(),
                                             onLiveSearch: Self.OnLiveSearch.eraseToAnyPublisher(),
                                             onArtistSelection: Self.OnArtistSelection.eraseToAnyPublisher())
}
