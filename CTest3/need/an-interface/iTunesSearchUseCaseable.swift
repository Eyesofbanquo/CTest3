//
//  iTunesSearchUseCase.swift
//  CTest3
//
//  Created by Markim Shaw on 2/23/21.
//

import Combine
import Foundation

protocol iTunesSearchUseCaseable: AnyObject {
  
  func searchArtists(usingName name: String) -> AnyPublisher<Result<[Artist], Error>, Never>
}
