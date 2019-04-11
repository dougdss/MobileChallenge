//
//  ApiPaymentInfo.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 10/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation

struct ApiTransactionInfo: Codable {
    
    let card_number: String
    let cvv: Int
    let value: Double
    let expiry_date: String
    let destination_user_id: Int
    
    enum CodingKeys: String, CodingKey {
        case card_number
        case cvv
        case value
        case expiry_date
        case destination_user_id
    }
    
    init(transactionInfo: TransactionInfo) {
        card_number = transactionInfo.cardNumber
        cvv = transactionInfo.cvv
        value = transactionInfo.value
        expiry_date = transactionInfo.expiryDate
        destination_user_id = transactionInfo.destinationUserId
    }
}
