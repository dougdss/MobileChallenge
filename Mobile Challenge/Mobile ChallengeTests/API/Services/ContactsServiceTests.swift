//
//  ContactsServiceTests.swift
//  Mobile ChallengeTests
//
//  Created by Douglas da Silva Santos on 05/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import XCTest
@testable import Mobile_Challenge

class ContactsServiceTests: XCTestCase {

    var sut: ContactsApiService!
    let apiServiceSpy = ApiServiceSpy()
    
    override func setUp() {
        super.setUp()
        sut = ContactsApiService(apiService: apiServiceSpy)
    }
    
    func test_successLoadingContactsFromService() {
        
        apiServiceSpy.successResponse = true
        
        let successExpectation = expectation(description: "Success Expectation")
        
        sut.getContacts { (result: Result<[Contact]>) in
            switch result {
            case .failure(_):
                XCTFail("Expected success response")
            case .success(let value):
                
                XCTAssertTrue(value.count == 1)
                XCTAssertEqual(value[0].name, "Eduardo Santos")
                XCTAssertEqual(value[0].id, 1001)
                XCTAssertEqual(value[0].imageUrl, "https://randomuser.me/api/portraits/men/9.jpg")
                XCTAssertEqual(value[0].username, "@eduardo.santos")
                
                successExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_failureLoadingContactsFromService() {
        apiServiceSpy.successResponse = false
        
        let failureExpectation = expectation(description: "failure Expectation")
        
        sut.getContacts { (result: Result<[Contact]>) in
            switch result {
            case .success(_):
                XCTFail("Expected Failure Result")
            case .failure(let error):
                guard let apiError = error as? ApiError else {
                    XCTFail("Expected ApiError type")
                    return
                }
                
                XCTAssertEqual(apiError.localizedDescription, "The data used for the parse was invalid")
                
                failureExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
}

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
