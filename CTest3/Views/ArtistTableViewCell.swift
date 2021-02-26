//
//  ArtistTableViewCell.swift
//  CTest3
//
//  Created by Markim Shaw on 2/26/21.
//

import Foundation
import UIKit

final class ArtistTableViewCell: UITableViewCell {
  
  lazy var artistNameLabel: UILabel = .header
  lazy var trackName: UILabel = .subHeader
  lazy var releaseDate: UILabel = .caption2
  lazy var primaryGenreName: UILabel = .caption1
  lazy var trackPrice: UILabel = .caption2
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupViews()
  }
  
  @available(*, unavailable, message: "No storyboards")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension ArtistTableViewCell {
  
  func setupViews() {
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 8.0
    stackView.distribution = .fill
    stackView.alignment = .firstBaseline
    
    stackView.addArrangedSubview(artistNameLabel)
    stackView.addArrangedSubview(trackName)
    stackView.addArrangedSubview(releaseDate)
    stackView.addArrangedSubview(primaryGenreName)
    
    self.addSubview(trackPrice)
    self.addSubview(stackView)

    
    NSLayoutConstraint.activate([
                                  trackPrice.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
                                  trackPrice.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
                                  stackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
                                  stackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
                                  stackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
                                  stackView.trailingAnchor.constraint(equalTo: trackPrice.leadingAnchor)])
  }
}

extension ArtistTableViewCell {
  static func configure(_ cell: ArtistTableViewCell, forArtist artist: Artist) {
    cell.artistNameLabel.text = artist.artistName
    cell.trackName.text = artist.trackName
    cell.primaryGenreName.text = artist.primaryGenreName
    cell.trackPrice.text = "\(artist.trackPrice ?? 0.0)"
    cell.releaseDate.text = artist.releaseDate
  }
}
