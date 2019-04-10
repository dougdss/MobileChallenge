//
//  ContactsMock.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 10/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation

struct ContactsMock {
    
    func getMockedContacts() -> [Contact]? {
        
        if let url = Bundle.main.url(forResource: "contacts", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let apiContacts = try decoder.decode([ApiContact].self, from: jsonData)
                let contacts = apiContacts.map({ $0.contact })
                return contacts
            } catch {
                return nil
            }
        }
        return nil
    }
    
}
