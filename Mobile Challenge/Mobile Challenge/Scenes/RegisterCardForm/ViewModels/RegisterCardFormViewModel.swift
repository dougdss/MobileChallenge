//
//  RegisterCardFormViewModel.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 07/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

class RegisterCardFormViewModel: RegisterCardFormViewModelType {
    
    var cardNumber: String = ""
    var holderName: String = ""
    var dueDate: Date = Date()
    var cvv: String = ""
 
    weak var viewDelegate: RegisterCardFormViewModelViewDelegate?
    weak var coordinatorDelegate: RegisterCardFormViewModelCoordinatorDelegate?
    
    private let service: CreditCardService
    
    init(creditCardService: CreditCardService) {
        self.service = creditCardService
    }
    
    func saveCard(card: CreditCard, from controller: UIViewController) {
        coordinatorDelegate?.didSaveCreditCard(creditCard: card, from: controller)
    }
    
    func didGoBack() {
        coordinatorDelegate?.didCallPop()
    }
}
