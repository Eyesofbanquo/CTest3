//
//  iTunesSearchState.swift
//  CTest3
//
//  Created by Markim Shaw on 2/23/21.
//

import Foundation

enum iTunesSearchState: Equatable {
  static func == (lhs: iTunesSearchState, rhs: iTunesSearchState) -> Bool {
    switch (lhs, rhs) {
      case (.idle, .idle): return true
      case (.loading, .loading): return true
      case (.error(let lError), .error(let rError)):
        return true
      case (.results(let lResults), .results(let rResults)):
        return true
      default: return false
    }
  }
  
  
  /// The default state for the `iTunesSearchController`. This is when no action has been performed.
  case idle
  
  /// This is when the `iTunesSearchController` is loading.
  case loading
  
  /// This is when the `iTunesSearchController` has thrown an error
  case error(error: Error)
  
  /// This is when the `iTunesSearchController` has finished searching.
  case results(artists: [Artist])

}
