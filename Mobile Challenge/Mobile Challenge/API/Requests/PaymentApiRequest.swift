//
//  PaymentApiRequest.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 10/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation

struct PaymentApiRequest: ApiRequest {

    var requestData: Data?
    init(transactionInfo: TransactionInfo) {
        let transac = ApiTransactionInfo(transactionInfo: transactionInfo)
        self.requestData = try? JSONEncoder().encode(transac)
    }
    
    var urlRequest: URLRequest {
        let url = URL(string: "http://careers.picpay.com/tests/mobdev/transaction")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpBody = requestData
        return request
    }
    
}
