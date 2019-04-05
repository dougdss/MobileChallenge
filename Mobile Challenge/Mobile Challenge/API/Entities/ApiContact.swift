//
//  ApiContact.swift
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
