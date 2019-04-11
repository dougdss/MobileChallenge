//
//  ReceiptsViewModelType.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 10/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

protocol ReceiptsViewModelType {
    
    var viewDelegate: ReceiptsViewModelViewDelegate? { get set }
    var contactUsername: String { get }
    var trasactionDate: String { get }
    var trasactionId: String { get }
    var cardName: String { get }
    var cardPaymentValue: String { get }
    var totalPayment: String { get }
    
    func contactImage(completion: @escaping (_ image: UIImage?) -> Void)
}

protocol ReceiptsViewModelCoordinatorDelegate:class {
    func didCloseReceipt()
}

protocol ReceiptsViewModelViewDelegate:class {
    
}
