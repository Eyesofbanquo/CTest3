//
//  Artist.swift
//  CTest3
//
//  Created by Markim Shaw on 2/25/21.
//

import Foundation

struct ArtistResult: Decodable {
  var resultCount: Int
  var results: [Artist]
}

struct Artist: Decodable, Hashable {
  static func ==(lhs: Artist, rhs: Artist) -> Bool {
    
    return lhs.id == rhs.id
  }
  
//  var id: String?
  var id: String
  var artistName: String?
  var trackName: String?
  var releaseDate: String?
  var primaryGenreName: String?
  var trackPrice: Double?
  
  enum ContainerCodingKeys: String, CodingKey {
    case resultCount, results
  }
  enum CodingKeys: String, CodingKey {
//    case id = "artistId"
    case artistName, trackName, releaseDate, primaryGenreName, trackPrice, collectionId
  }
}

extension Artist {
  init(from decoder: Decoder) throws {
    let resultsContainer = try decoder.container(keyedBy: CodingKeys.self)
    
    self.artistName = try resultsContainer.decodeIfPresent(String.self, forKey: .artistName)
    self.trackName = try resultsContainer.decodeIfPresent(String.self, forKey: .trackName)
    self.releaseDate = try resultsContainer.decodeIfPresent(String.self, forKey: .releaseDate)
    self.primaryGenreName = try resultsContainer.decodeIfPresent(String.self, forKey: .primaryGenreName)
    self.trackPrice = try resultsContainer.decodeIfPresent(Double.self, forKey: .trackPrice)
    self.id = UUID().uuidString
  }
}
