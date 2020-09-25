//
//  ImageGalleryDemoTests.swift
//  ImageGalleryDemoTests
//
//  Created by Jadhav, V. A. on 20/09/2020.
//  Copyright © 2020 Vrushali. All rights reserved.
//

import XCTest
@testable import ImageGalleryDemo

class ImageGalleryDemoTests: XCTestCase {

    var session: URLSession!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        session = URLSession(configuration: .default)
        
    }

    func testAPICallGetGalleryImages() {
        
      let requestURL = URL(string:"\(baseURL)hot/viral/day/1")!
      var request = URLRequest(url: requestURL)
      request.httpMethod = "GET"
      request.addValue("application/json", forHTTPHeaderField:"Content-Type")
      request.addValue("Client-ID \(clientId)", forHTTPHeaderField:"Authorization")
      
      let promise = expectation(description: "Status code: 200")

      let dataTask = session.dataTask(with:request as URLRequest, completionHandler: {
      (data: Data?, response: URLResponse?, error: Error?) in
        
        if let error = error {
          XCTFail("Error: \(error.localizedDescription)")
          return
        } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
          if statusCode == 200 {
            
            promise.fulfill()
          } else {
            XCTFail("Status code: \(statusCode)")
          }
        }
      })
      dataTask.resume()
      wait(for: [promise], timeout: 10)
    }
    
    func testSearchAPI () {
        
      let requestURL = URL(string:"\(baseURL)search/hot/viral/1?q=cat")!
      var request = URLRequest(url: requestURL)
      request.httpMethod = "GET"
      request.addValue("application/json", forHTTPHeaderField:"Content-Type")
      request.addValue("Client-ID \(clientId)", forHTTPHeaderField:"Authorization")
      
      let promise = expectation(description: "Status code: 200")

      let dataTask = session.dataTask(with:request as URLRequest, completionHandler: {
      (data: Data?, response: URLResponse?, error: Error?) in
        
        if let error = error {
          XCTFail("Error: \(error.localizedDescription)")
          return
        } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
          if statusCode == 200 {
            
            promise.fulfill()
          } else {
            XCTFail("Status code: \(statusCode)")
          }
        }
      })
      dataTask.resume()
      wait(for: [promise], timeout: 10)
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        session = nil
        super.tearDown()
    }

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
