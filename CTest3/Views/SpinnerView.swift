//
//  SpinnerView.swift
//  CTest3
//
//  Created by Markim Shaw on 2/26/21.
//

import Foundation
import UIKit

final class SpinnerView: UIView {
  
  lazy var activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .medium)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    indicator.hidesWhenStopped = true
    return indicator
  }()
  
  init() {
    super.init(frame: .zero)
    
    self.addSubview(activityIndicator)
    
    NSLayoutConstraint.activate([
                                  activityIndicator.topAnchor.constraint(equalTo: self.topAnchor),
                                  activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
