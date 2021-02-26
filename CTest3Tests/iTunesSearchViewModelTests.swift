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
  var mockInput: MockInput!
  var network: Network!
  var cancellables: Set<AnyCancellable>!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    
    let urlSession = URLSession(configuration: configuration)
//    network = Network(session: urlSession)
    network = Network()
    
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
    
    MockInput.OnAppear.send(())
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
    
    MockInput.OnAppear.send(())
    _ = XCTWaiter.wait(for: [ex!], timeout: 1.0)
    XCTAssertEqual(currentState, iTunesSearchState.idle)

    ex = XCTestExpectation(description: "working...")
    
    MockInput.OnSearch.send("Prince")
    _ = XCTWaiter.wait(for: [ex!], timeout: 1.0)
    XCTAssertEqual(currentState, iTunesSearchState.results(artists: []))

  }
  
  func testSearchViewModel_resultsToIdle() {
    var ex: XCTestExpectation? = XCTestExpectation(description: "working...")
    
    var currentState: iTunesSearchState?
    XCTAssertNil(currentState)
    
    sut.transform(input: mockInput).sink { state in
      currentState = state
      ex?.fulfill()
      ex = nil
      
    }.store(in: &cancellables)
    
    MockInput.OnAppear.send(())
    _ = XCTWaiter.wait(for: [ex!], timeout: 1.0)
    XCTAssertEqual(currentState, iTunesSearchState.idle)
    
    ex = XCTestExpectation(description: "working...")
    
    MockInput.OnSearch.send("Prince")
    _ = XCTWaiter.wait(for: [ex!], timeout: 1.0)
    XCTAssertEqual(currentState, iTunesSearchState.results(artists: []))
    
    ex = XCTestExpectation(description: "working...")
    
    MockInput.OnSearch.send("")
    _ = XCTWaiter.wait(for: [ex!], timeout: 1.0)
    XCTAssertEqual(currentState, iTunesSearchState.idle)
    
  }
  
  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
