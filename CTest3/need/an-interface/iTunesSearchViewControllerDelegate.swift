//
//  iTunesSearchViewControllerDelegate.swift
//  CTest3
//
//  Created by Markim Shaw on 2/26/21.
//

import Foundation

protocol iTunesSearchViewControllerDelegate: AnyObject {
  
  func updateTable(artists: [Artist], animated: Bool)
  
  
}
