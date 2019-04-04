//
//  ContactViewDataType.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 04/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

protocol ContactViewDataType {
 
    var userImage: UIImage? { get }
    var username: String { get }
    var name: String { get }
    
}

struct ContactViewData: ContactViewDataType {
    
    
    var username: String {
        return contact.username
    }
    
    var name: String {
        return contact.name
    }
    
    var userImage: UIImage? {
        return nil
    }
    
    let contact: Contact

    init(contact: Contact) {
        self.contact = contact
    }
    
}
