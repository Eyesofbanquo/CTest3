//
//  iTunesSearchViewModelTestsMocks.swift
//  CTest3Tests
//
//  Created by Markim Shaw on 2/26/21.
//

import Foundation

extension iTunesSearchViewModelTests {
  func setupMockResponse() {
    MockURLProtocol.requestHandler = { request in
      let jsonData = """
      {
      "resultCount": 22,
      "results": [
      {
      "artistId": 155814,
      "artistName": "Prince",
      "artistViewUrl": "https://music.apple.com/us/artist/prince/155814?uo=4",
      "artworkUrl100": "https://is5-ssl.mzstatic.com/image/thumb/Music124/v4/d7/e0/5a/d7e05abc-f064-e4d6-d22b-56f2d2897955/source/100x100bb.jpg",
      "artworkUrl30": "https://is5-ssl.mzstatic.com/image/thumb/Music124/v4/d7/e0/5a/d7e05abc-f064-e4d6-d22b-56f2d2897955/source/30x30bb.jpg",
      "artworkUrl60": "https://is5-ssl.mzstatic.com/image/thumb/Music124/v4/d7/e0/5a/d7e05abc-f064-e4d6-d22b-56f2d2897955/source/60x60bb.jpg",
      "collectionCensoredName": "1999",
      "collectionExplicitness": "explicit",
      "collectionId": 1544173941,
      "collectionName": "1999",
      "collectionPrice": 9.99,
      "collectionViewUrl": "https://music.apple.com/us/album/international-lover-2019-remaster/1544173941?i=1544173952&uo=4",
      "country": "USA",
      "currency": "USD",
      "discCount": 1,
      "discNumber": 1,
      "isStreamable": true,
      "kind": "song",
      "previewUrl": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview124/v4/48/02/8f/48028f34-c32e-9518-276b-e1f6d6e70b96/mzaf_2504756718620421746.plus.aac.p.m4a",
      "primaryGenreName": "R&B/Soul",
      "releaseDate": "1982-10-27T07:00:00Z",
      "trackCensoredName": "International Lover (2019 Remaster)",
      "trackCount": 11,
      "trackExplicitness": "notExplicit",
      "trackId": 1544173952,
      "trackName": "International Lover",
      "trackNumber": 11,
      "trackPrice": 1.29,
      "trackTimeMillis": 397827,
      "trackViewUrl": "https://music.apple.com/us/album/international-lover-2019-remaster/1544173941?i=1544173952&uo=4",
      "wrapperType": "track"
      }
      ]
      }
      """
      
      let data = jsonData.data(using: .utf8)
      let response = HTTPURLResponse.init(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
      
      return (response, data!)
    }
    

  }
}
