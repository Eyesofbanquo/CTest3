//
//  UITableViewCell+.swift
//  CTest3
//
//  Created by Markim Shaw on 2/26/21.
//

import Foundation
import UIKit

extension UITableViewCell {
  
  static var reuseIdentifier: String {
    return String(reflecting: Self.self)
  }
}
