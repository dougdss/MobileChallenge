//
//  ContactsService.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 04/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation

struct ApiContact: Decodable {
    
    var id: Int
    var name: String
    var img: String
    var username: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case img
        case username
    }
    
    var contact: Contact {
        return Contact(id: id, name: name, imageUrl: img, username: username)
    }
    
}

struct ContactsRequest: ApiRequest {
    
    var urlRequest: URLRequest {
        let url = URL(string: "http://careers.picpay.com/tests/mobdev/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}

protocol ContactsService {
    func getContacts(completion: @escaping (Result<[Contact]>) -> Void)
}


class ContactsApiService {
    
    let apiService: ApiService
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
}

extension ContactsApiService: ContactsService {
    
    func getContacts(completion: @escaping (Result<[Contact]>) -> Void) {
        
        apiService.execute(request: ContactsRequest()) { (result: Result<ApiResponse<[ApiContact]>>) in
            switch result {
            case .success(let contactsResponse):
                let contacts = contactsResponse.entity!.map({ $0.contact })
                completion(.success(contacts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
}
