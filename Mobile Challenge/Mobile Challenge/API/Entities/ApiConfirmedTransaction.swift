//
//  ApiConfirmedTransaction.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 10/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation


struct ApiConfirmedTransaction: Decodable {
    
    let transaction: ApiTransaction
    
    enum CodingKeys: String, CodingKey {
        case transaction
    }
    
    struct ApiTransaction:Decodable {
        
        let success: Bool
        let status: String
        let id: Int
        let timestamp: Int64
        let value: Double
        let destination_user: ApiContact
        
        enum CodingKeys: String, CodingKey {
            case success
            case status
            case id
            case timestamp
            case value
            case destination_user
        }

        var transaction: ConfirmedTransaction.Transaction {
            return ConfirmedTransaction.Transaction.init(success: success, status: status, id: id, timestamp: timestamp, value: value, destinationUser: destination_user.contact)
            
        }
    }
    
    var confirmedTransaction: ConfirmedTransaction {
        return ConfirmedTransaction.init(transaction: transaction.transaction)
    }
    
}
