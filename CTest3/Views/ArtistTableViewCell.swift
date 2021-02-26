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
    
    trackPrice.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    trackPrice.setContentCompressionResistancePriority(.required, for: .horizontal)
    
    artistNameLabel.numberOfLines = 2
    artistNameLabel.lineBreakMode = .byTruncatingTail
    
    trackName.numberOfLines = 2
    trackName.lineBreakMode = .byTruncatingTail
    
    let mainStackView = UIStackView()
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.axis = .horizontal
    mainStackView.spacing = 8.0
    mainStackView.distribution = .fill
    mainStackView.alignment = .top
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.alignment = .fill
        
    stackView.addArrangedSubview(artistNameLabel)
    stackView.addArrangedSubview(trackName)
    stackView.addArrangedSubview(releaseDate)
    stackView.addArrangedSubview(primaryGenreName)
        
    mainStackView.addArrangedSubview(stackView)
    mainStackView.addArrangedSubview(trackPrice)
    self.addSubview(mainStackView)

    
    NSLayoutConstraint.activate([
                                  mainStackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
                                  mainStackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
                                  mainStackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
                                  mainStackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)])
  }
}

extension ArtistTableViewCell {
  static func configure(_ cell: ArtistTableViewCell, forArtist artist: Artist) {
    cell.artistNameLabel.text = artist.artistName
    cell.trackName.text = artist.trackName
    cell.primaryGenreName.text = artist.primaryGenreName
    cell.trackPrice.text = "$\(artist.trackPrice ?? 00.00)"
    cell.releaseDate.text = artist.releaseDate
  }
}
