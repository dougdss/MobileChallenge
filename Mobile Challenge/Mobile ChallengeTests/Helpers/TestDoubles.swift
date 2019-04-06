//
//  TestDoubles.swift
//  Mobile ChallengeTests
//
//  Created by Douglas da Silva Santos on 06/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation
@testable import Mobile_Challenge

struct TestDoubleRequest: ApiRequest {
    
    var urlRequest: URLRequest {
        return URLRequest(url: URL(string: "google.com")!)
    }
}

struct TestDoubleApiEntity: Decodable {
    var test_string: String
    
    enum CodingKeys: String, CodingKey {
        case test_string
    }
}

class TestDoubleApiEntityParseError: Decodable {
    var test_string: String
    
    enum CodingKeys: String, CodingKey {
        case test_string
    }
    
    required init(from decoder: Decoder) throws {
        throw NSError(domain: "challenge.parse.error", code: 999, userInfo: [NSLocalizedDescriptionKey: "Error parsing JSON data"])
    }
}
