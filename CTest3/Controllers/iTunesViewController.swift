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
  
  lazy var searchBar: UISearchBar = createSearchBar()
  
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
    self.view.addSubview(searchBar)
    
    setupSearchBar()
    
    onAppear.send(())
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    NSLayoutConstraint.activate([
      searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      searchBar.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
      searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      
      searchView.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      searchView.view.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
      searchView.view.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
      searchView.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
    ])
  }
  
  func bind(to viewModel: iTunesSearchTransformable) {
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
    
    viewModel.transform(input: iTunesSearchViewInput(onAppear: onAppear.eraseToAnyPublisher(), onSearch: onSearch.eraseToAnyPublisher(), onLiveSearch: onLiveSearch.eraseToAnyPublisher(), onArtistSelection: onArtistSelection.eraseToAnyPublisher()))
      .sink { [weak self] state in
        
        switch state {
          case .idle: break
          case .results(artists: let artists):
            self?.searchView.searchFinished()
            
            if self?.searchBar.text?.isEmpty == true, artists.isEmpty == false {
              self?.searchView.updateTable(artists: [], animated: true)
            } else {
              self?.searchView.updateTable(artists: artists, animated: true)
            }
          default: break
        }
      }.store(in: &cancellables)
  }
}

extension iTunesViewController {
  func createSearchBar() -> UISearchBar {
    let bar = UISearchBar()
    bar.translatesAutoresizingMaskIntoConstraints = false
    bar.showsCancelButton = true
    bar.barStyle = .default
    return bar
  }
  
  func setupSearchBar() {
    searchBar.delegate = self
  }
}

extension iTunesViewController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchView.searchBegan()
    onSearch.send(searchText)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    onAppear.send(())
  }
}
