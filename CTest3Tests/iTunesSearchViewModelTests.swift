//
//  iTunesSearchViewModelTests.swift
//  CTest3Tests
//
//  Created by Markim Shaw on 2/25/21.
//

import Combine
import Foundation
import XCTest

@testable import CTest3

class iTunesSearchViewModelTests: XCTestCase {
  
  var sut: iTunesSearchViewModel!
  var mockInput: iTunesSearchViewInput!
  var network: Network!
  var cancellables: Set<AnyCancellable>!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    setupMockResponse()
    
    let urlSession = URLSession(configuration: configuration)
    network = Network(session: urlSession)
    
    mockInput = .standard
    
    sut = iTunesSearchViewModel(network: network)
    
    cancellables = Set<AnyCancellable>()
  }
  
  override func tearDownWithError() throws {
    sut = nil
    
    try super.tearDownWithError()
  }
  
  func testSearchViewModel_toIdleState() {
    sut.transform(input: mockInput).sink { state in
      XCTAssertEqual(state, iTunesSearchState.idle)
    }.store(in: &cancellables)
    
    iTunesSearchViewInput.OnAppear.send(())
  }
  
  func testSearchViewModel_idleToSearchState() {
    var ex: XCTestExpectation? = XCTestExpectation(description: "working...")
    
    var currentState: iTunesSearchState?
    XCTAssertNil(currentState)
    
    sut.transform(input: mockInput).sink { state in
      currentState = state
      ex?.fulfill()
      ex = nil
    }.store(in: &cancellables)
    
    iTunesSearchViewInput.OnAppear.send(())
    _ = XCTWaiter.wait(for: [ex!], timeout: 1.0)
    XCTAssertEqual(currentState, iTunesSearchState.idle)

    ex = XCTestExpectation(description: "working...")
    
    iTunesSearchViewInput.OnSearch.send("Prince")
    _ = XCTWaiter.wait(for: [ex!], timeout: 1.0)
    XCTAssertEqual(currentState, iTunesSearchState.results(artists: []))

  }
  
  func testSearchViewModel_searchToIdleState() {
    var ex: XCTestExpectation? = XCTestExpectation(description: "working...")
    
    var currentState: iTunesSearchState?
    XCTAssertNil(currentState)
    
    sut.transform(input: mockInput).sink { state in
      currentState = state
      ex?.fulfill()
      ex = nil
      
    }.store(in: &cancellables)
    
    iTunesSearchViewInput.OnAppear.send(())
    _ = XCTWaiter.wait(for: [ex!], timeout: 1.0)
    XCTAssertEqual(currentState, iTunesSearchState.idle)
    
    ex = XCTestExpectation(description: "working...")
    
    iTunesSearchViewInput.OnSearch.send("Prince")
    _ = XCTWaiter.wait(for: [ex!], timeout: 1.0)
    XCTAssertEqual(currentState, iTunesSearchState.results(artists: []))
    
    ex = XCTestExpectation(description: "working...")
    
    iTunesSearchViewInput.OnSearch.send("")
    _ = XCTWaiter.wait(for: [ex!], timeout: 1.0)
    XCTAssertEqual(currentState, iTunesSearchState.idle)
    
  }
  
}
