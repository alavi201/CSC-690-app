//
//  Twitter_Clone_Tests.swift
//  Twitter-Clone-Tests
//
//  Created by Ali Alavi on 5/16/19.
//  Copyright © 2019 SFSU. All rights reserved.
//

import XCTest
@testable import Twitter_Clone

class Twitter_Clone_Tests: XCTestCase {

    var sessionUnderTest: URLSession!
    
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    func testValidCallToServerGetsHTTPStatusCode200() {
        // given
        let url = URL(string: "http://127.0.0.1:8081")
        // 1
        let promise = expectation(description: "Status code: 200")
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // 2
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        // 3
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAuthToken() {
        // given
        let url = URL(string: "http://127.0.0.1:8081/loginTest")
        // 1
        let promise = expectation(description: "authToken")
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            // then
            let json = try! JSONSerialization.jsonObject(with: data!, options: [])
            
            guard let jsonArray = json as? [String: Any] else {
                return
            }
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 && jsonArray["authToken"] != nil {
                    promise.fulfill()
                } else {
                    XCTFail("authToken")
                }
            }
        }
        dataTask.resume()
        // 3
        waitForExpectations(timeout: 5, handler: nil)
    }
}
