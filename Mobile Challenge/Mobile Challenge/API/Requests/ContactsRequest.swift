//
//  ContactsRequest.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 04/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation

struct ContactsRequest: ApiRequest {
    
    var urlRequest: URLRequest {
        let url = URL(string: "http://careers.picpay.com/tests/mobdev/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
