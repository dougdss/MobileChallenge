//
//  UrlSessionStub.swift
//  Mobile ChallengeTests
//
//  Created by Douglas da Silva Santos on 06/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation
@testable import Mobile_Challenge

class URLSessionProtocolStub: URLSessionProtocol {
    
    typealias URLSessionStubCompletionResponse = (data: Data?, response: URLResponse?, error: Error?)
    var response: URLSessionStubCompletionResponse = URLSessionStubCompletionResponse(data: nil, response: nil, error: nil)
    
    func setResponse(response: URLSessionStubCompletionResponse) {
        self.response = response
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return StubTask(response: response, completionHandler: completionHandler)
    }
    
    private class StubTask: URLSessionDataTask {
        let testDoubleResponse: URLSessionStubCompletionResponse
        let completionHandler: (Data?, URLResponse?, Error?) -> Void
        
        init(response: URLSessionStubCompletionResponse, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
            self.testDoubleResponse = response
            self.completionHandler = completionHandler
        }
        
        override func resume() {
            completionHandler(testDoubleResponse.data, testDoubleResponse.response, testDoubleResponse.error)
        }
        
    }
    
}
