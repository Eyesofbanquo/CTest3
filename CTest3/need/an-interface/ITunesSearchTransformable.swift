//
//  ITunesSearchTransformable.swift
//  CTest3
//
//  Created by Markim Shaw on 2/23/21.
//

import Foundation

protocol iTunesSearchTransformable: AnyObject {
  func transform(input: iTunesSearchViewInput) -> ITunesSearchViewOutput
}
