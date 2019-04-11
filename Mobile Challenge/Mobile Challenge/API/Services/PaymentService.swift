//
//  PaymentService.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 09/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation

protocol PaymentService {
    func confirmTransaction(transaction: TransactionInfo, completion: @escaping (Result<ConfirmedTransaction>) -> Void)
}

class PaymentApiService {
    
    let apiService: ApiService
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
}

extension PaymentApiService: PaymentService {
    
    func confirmTransaction(transaction: TransactionInfo, completion: @escaping (Result<ConfirmedTransaction>) -> Void) {
        
        apiService.execute(request: PaymentApiRequest(transactionInfo: transaction)) { (result: Result<ApiResponse<ApiConfirmedTransaction>>) in
            switch result {
            case .success(let value):
                let confirmedTransaction = value.entity!.confirmedTransaction
                completion(.success(confirmedTransaction))
            case .failure(let error):
                   completion(.failure(error))
            }
        }
        
    }
    
}
