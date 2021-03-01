//
//  iTunesSearchViewControllerDelegate.swift
//  CTest3
//
//  Created by Markim Shaw on 2/26/21.
//

import UIKit
import Foundation

protocol iTunesSearchViewControllerDelegate: AnyObject {
  
  var view: UIView { get }
  
  func updateTable(artists: [Artist], animated: Bool)
  
  func searchBegan()
  
  func searchFinished()
  
}
