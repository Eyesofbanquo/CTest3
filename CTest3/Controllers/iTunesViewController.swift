//
//  iTunesViewController.swift
//  CTest3
//
//  Created by Markim Shaw on 2/26/21.
//

import Combine
import Foundation
import UIKit

final class iTunesViewController: UIViewController {
  
  lazy var viewModel: iTunesSearchTransformable = iTunesSearchViewModel()
  
  lazy var searchView: iTunesSearchViewControllerDelegate = iTunesSearchView()
  
  let onAppear = PassthroughSubject<Void, Never>()
  
  let onSearch = PassthroughSubject<String, Never>()
  
  let onLiveSearch = PassthroughSubject<String, Never>()
  
  let onArtistSelection = PassthroughSubject<IndexPath, Never>()
  
  var cancellables = Set<AnyCancellable>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bind(to: viewModel)
    
    searchView.view.translatesAutoresizingMaskIntoConstraints = false
    
    self.view.backgroundColor = .systemBackground
    self.view.addSubview(searchView.view)
    
    onAppear.send(())
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    NSLayoutConstraint.activate([
                                  searchView.view.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
                                  searchView.view.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
                                  searchView.view.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
                                  searchView.view.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor)])
    
    onSearch.send("Prince")
  }
  
  func bind(to viewModel: iTunesSearchTransformable) {
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
    
    viewModel.transform(input: iTunesSearchViewInput(onAppear: onAppear.eraseToAnyPublisher(), onSearch: onSearch.eraseToAnyPublisher(), onLiveSearch: onLiveSearch.eraseToAnyPublisher(), onArtistSelection: onArtistSelection.eraseToAnyPublisher()))
      .sink { [weak self] state in
        
        switch state {
          case .idle: break
          case .results(artists: let artists):
            self?.searchView.updateTable(artists: artists, animated: true)
          default: break
        }
      }.store(in: &cancellables)
  }
}
