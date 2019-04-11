//
//  ApiServiceSpy.swift
//  Mobile ChallengeTests
//
//  Created by Douglas da Silva Santos on 06/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation
@testable import Mobile_Challenge

class ApiServiceSpy: ApiService {
    
    var successResponse = false
    func execute<T>(request: ApiRequest, completionHandler: @escaping (Result<ApiResponse<T>>) -> Void) where T : Decodable {
        
        let successContactsApiResponse = try! ApiResponse<T>(data: contactsData(), httpResponse: nil)
        if successResponse {
            completionHandler(Result.success(successContactsApiResponse))
        } else {
            let apiError = ApiError(data: nil, httpUrlResponse: nil, error: ParseError.invalidData)
            completionHandler(Result.failure(apiError))
        }
        
    }
    
    private func contactsData() -> Data {
        let stringResponse =
        "[{ \"id\": 1001, \"name\": \"Eduardo Santos\", \"img\": \"https://randomuser.me/api/portraits/men/9.jpg\", \"username\": \"@eduardo.santos\" }]"
        let contactsData = stringResponse.data(using: .utf8)
        return contactsData!
    }
}
