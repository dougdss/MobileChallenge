//
//  ApiResponse.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 04/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation

struct ApiResponse<T: Decodable> {
    
    var data: Data?
    var httpUrlResponse: HTTPURLResponse?
    var entity: T?
    
    init(data: Data?, httpResponse: HTTPURLResponse?) throws {
        self.data = data
        self.httpUrlResponse = httpResponse
        
        do {
            self.entity = try parseEntity()
        } catch {
            throw ApiParseError(data: data, httpUrlResponse: httpResponse, error: error)
        }
    }
    
    func parseEntity() throws -> T {
        guard let validData = self.data else {
            throw ApiParseError(data: self.data, httpUrlResponse: self.httpUrlResponse, error: ParseError.invalidData)
        }
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(T.self, from: validData)
        return decoded
    }
}
