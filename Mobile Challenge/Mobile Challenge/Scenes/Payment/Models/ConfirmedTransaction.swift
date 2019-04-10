//
//  ConfirmedTransaction.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 09/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation

struct ConfirmedTransaction {
    
    let transaction: Transaction
    
    struct Transaction {
        let success: Bool
        let status: String
        let id: Int
        let timestamp: Int64
        let value: Double
        let destinationUser: Contact
    }
    
}
