//
//  APITests.swift
//  Mobile ChallengeTests
//
//  Created by Douglas da Silva Santos on 04/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import XCTest
@testable import Mobile_Challenge

class ApiClientTests: XCTestCase {
    
    var sut: ApiClient!
    let sessionProtocolStub = URLSessionProtocolStub()
    
    override func setUp() {
        super.setUp()
        sut = ApiClient(urlSession: sessionProtocolStub)
    }
    
    func test_executeSuccessRequestParsingResponse() {
        
        let apiRequest = TestDoubleRequest()
        let expectedUtf8StringResponse =
        "[{ \"id\": 1001, \"name\": \"Eduardo Santos\", \"img\": \"https://randomuser.me/api/portraits/men/9.jpg\", \"username\": \"@eduardo.santos\" }]"
        let expectedData = expectedUtf8StringResponse.data(using: .utf8)
        let expected2xxResponse = HTTPURLResponse(url: apiRequest.urlRequest.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        sessionProtocolStub.setResponse(response: (data: expectedData, response: expected2xxResponse, error: nil))
        
        let executeExpectation = expectation(description: "success request expectation")
        
        sut.execute(request: apiRequest) { (result: Result<ApiResponse<[ApiContact]>>) in
            switch result {
            case .failure(_):
                XCTFail("Should have received a success response")
            case .success(let value):
                let contacts = value.entity!.map({ $0.contact })
                XCTAssertEqual(contacts.count, 1, "The response is different")
                XCTAssertEqual(contacts[0].id, 1001, "The parsed response is different")
                XCTAssertEqual(contacts[0].name, "Eduardo Santos", "The parsed response is different")
                XCTAssertEqual(contacts[0].username, "@eduardo.santos", "The parsed response is different")
                XCTAssertEqual(contacts[0].imageUrl, "https://randomuser.me/api/portraits/men/9.jpg", "The parsed response is different")
                XCTAssertTrue(expected2xxResponse === value.httpUrlResponse, "The response is not the expected one")
                XCTAssertEqual(expectedData?.base64EncodedString(), value.data?.base64EncodedString(), "The response data is not the expected one")
                
                executeExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_executeSuccessRequestWithErrorParsingResponse() {
        let apiRequest = TestDoubleRequest()
        let expectedUtf8StringResponse = "{ \"test\": \"value\" }"
        let expectedData = expectedUtf8StringResponse.data(using: .utf8)
        let expected2xxResponse = HTTPURLResponse(url: apiRequest.urlRequest.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let expectedErrorMessage = "Error parsing JSON data"
        
        sessionProtocolStub.setResponse(response: (data: expectedData, response: expected2xxResponse, error: nil))
        
        let executeExpectation = expectation(description: "success request expectation")
        
        sut.execute(request: apiRequest) { (result: Result<ApiResponse<TestDoubleApiEntityParseError>>) in
            switch result {
            case .success(_):
                XCTFail("Expected Parse error to Happen")
            case .failure(let error):
                guard let parseError = error as? ApiParseError else {
                    XCTFail("Expected Parse error to Happen")
                    return
                }
                XCTAssertTrue(expected2xxResponse === parseError.httpUrlResponse, "the response is not the expected one")
                XCTAssertEqual(expectedData?.base64EncodedString(), parseError.data?.base64EncodedString(), "The response data is not the expected one")
                XCTAssertEqual(expectedErrorMessage, parseError.error?.localizedDescription, "wrong error message")
                
                executeExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_executeFailureWithHttpResponseCode() {
        
        let apiRequest = TestDoubleRequest()
        let expectedUtf8StringResponse = "{ \"test\": \"value\" }"
        let expectedData = expectedUtf8StringResponse.data(using: .utf8)
        let expected4xxResponse = HTTPURLResponse(url: apiRequest.urlRequest.url!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        sessionProtocolStub.setResponse(response: (data: expectedData, response: expected4xxResponse, error: nil))
        
        let executeExpectation = expectation(description: "request error expectation")
        
        sut.execute(request: apiRequest) { (result: Result<ApiResponse<TestDoubleApiEntity>>) in
            switch result {
            case .success(_):
                XCTFail("Expected Failure Response")
            case .failure(let error):
                guard let apiError = error as? ApiError else {
                    XCTFail("Expected failure apiError")
                    return
                }
                
                XCTAssertTrue(expected4xxResponse === apiError.httpUrlResponse, "The response is not the expected one")
                XCTAssertEqual(expectedData?.base64EncodedString(), apiError.data?.base64EncodedString(), "The response data is not the expected one")
                
                executeExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_executeFailureWithNoHttpResponse() {
        let apiRequest = TestDoubleRequest()
        
        let expectedErrorMessage = "A Network error has occured"
        let expectedError = NSError(domain: "challenge.network.error", code: 998, userInfo: [NSLocalizedDescriptionKey: expectedErrorMessage])
        
        sessionProtocolStub.setResponse(response: (data: nil, response: nil, error: expectedError))
        
        let executeExpectation = expectation(description: "network error expectation")
        
        sut.execute(request: apiRequest) { (result: Result<ApiResponse<TestDoubleApiEntity>>) in
            switch result {
            case .success(_):
                XCTFail("Expected a network error")
            case .failure(let error):
                guard let networkError = error as? NetworkError else {
                    XCTFail("Expected error to be of NetworkError type")
                    return
                }
                
                XCTAssertEqual(expectedErrorMessage, networkError.localizedDescription, "Error message does not match")
                
                executeExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
}
