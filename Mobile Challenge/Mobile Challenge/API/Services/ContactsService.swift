//
//  ContactsService.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 04/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation

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
