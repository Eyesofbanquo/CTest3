//
//  iTunesSearchView.swift
//  CTest3
//
//  Created by Markim Shaw on 2/26/21.
//

import Foundation
import UIKit

final class iTunesSearchView: UIView {
  
  lazy var tableView: UITableView = setupTableView()
  
  lazy var dataSource: UITableViewDiffableDataSource<iTunesSearchViewSection, Artist> = makeDataSource()
  
  lazy var spinner: SpinnerView = SpinnerView()
  
  init() {
    super.init(frame: .zero)
    
    self.addSubview(tableView)
    setupTableViewDataSource()
    
    spinner.frame = CGRect(x: 0.0, y: 0.0, width: 24.0, height: 24.0)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    layoutTableView()
  }
  
  @available(*, unavailable, message: "Not using storyboards")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension iTunesSearchView: iTunesSearchViewControllerDelegate {
  
  var view: UIView {
    self
  }
  
  func setupTableView() -> UITableView {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    tableView.register(ArtistTableViewCell.self, forCellReuseIdentifier: ArtistTableViewCell.reuseIdentifier)
    tableView.tableHeaderView = spinner
    
    return tableView
  }
  
  func setupTableViewDataSource() {
    tableView.dataSource = dataSource
  }
  
  func layoutTableView() {
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
    ])
  }
  
  func makeDataSource() -> UITableViewDiffableDataSource<iTunesSearchViewSection, Artist> {
    return UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, item -> UITableViewCell? in
      let cell = tableView.dequeueReusableCell(withIdentifier: ArtistTableViewCell.reuseIdentifier, for: indexPath)
      
      guard let artistCell = cell as? ArtistTableViewCell else { return cell }
      
      ArtistTableViewCell.configure(artistCell, forArtist: item)
      
      return cell
    }
  }
  
  func updateTable(artists: [Artist], animated: Bool) {
    var snapshot = NSDiffableDataSourceSnapshot<iTunesSearchViewSection, Artist>()
    snapshot.appendSections(iTunesSearchViewSection.allCases)
    snapshot.appendItems(artists, toSection: .artists)
    
    dataSource.apply(snapshot, animatingDifferences: animated)
  }
  
  func searchBegan() {
    spinner.activityIndicator.startAnimating()
  }
  
  func searchFinished() {
    spinner.activityIndicator.stopAnimating()
  }
}
