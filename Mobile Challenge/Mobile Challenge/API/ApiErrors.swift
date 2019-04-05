//
//  ApiErrors.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 04/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation

enum ParseError: Error, LocalizedError {
    case invalidData
    case parse
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return NSLocalizedString("The data used for the parse was invalid", comment: "ParseError")
        case .parse:
            return NSLocalizedString("Could not parse the response", comment: "ParseError")
        }
    }
    
//    var localizedDescription: String {
//        switch self {
//        case .invalidData:
//            return "The data used for the parse was invalid"
//        case .parse:
//            return "Could not parse the response"
//        }
//    }
}

struct ApiParseError: Error {
    
    var data: Data?
    var httpUrlResponse: HTTPURLResponse?
    var error: Error?

    var localizedDescription: String {
        return error?.localizedDescription ?? "could not parse response"
    }
}

struct ApiError: Error {
    
    var data: Data?
    var httpUrlResponse: HTTPURLResponse?
    var error: Error?
    
    var localizedDescription: String {
        return error?.localizedDescription ?? "Unknow Error, did not received a success status code"
    }
}

struct NetworkError: Error {
    
    let error: Error?
    
    var localizedDescription: String {
        return error?.localizedDescription ?? "unknow network error"
    }
    
}
