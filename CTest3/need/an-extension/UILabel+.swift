//
//  UILabel+.swift
//  CTest3
//
//  Created by Markim Shaw on 2/26/21.
//

import Foundation
import UIKit

extension UILabel {
  
  fileprivate static var prototypeLabel: UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .label
    return label
  }
  
  static var header: UILabel {
    let label = Self.prototypeLabel
    label.font = .preferredFont(forTextStyle: .headline)
    return label
  }
  
  static var subHeader: UILabel {
    let label = Self.prototypeLabel
    label.font = .preferredFont(forTextStyle: .subheadline)
    return label
  }
  
  static var caption1: UILabel {
    let label = Self.prototypeLabel
    label.font = .preferredFont(forTextStyle: .caption1)
    return label
  }
  
  static var caption2: UILabel {
    let label = Self.prototypeLabel
    label.font = .preferredFont(forTextStyle: .caption2)
    return label
  }
}
