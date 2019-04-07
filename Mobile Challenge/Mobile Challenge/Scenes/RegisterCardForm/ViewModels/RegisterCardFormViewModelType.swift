//
//  RegisterCardFormViewModelType.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 07/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

protocol RegisterCardFormViewModelType {
    
    var viewDelegate: RegisterCardFormViewModelViewDelegate? { get set }

    var cardNumber: String { get set }
    var holderName: String { get set }
    var dueDate: Date { get set }
    var cvv: String { get set }
    
}

protocol RegisterCardFormViewModelCoordinatorDelegate:class {
    func didSaveCreditCard(creditCard: CreditCard, from controller: UIViewController)
}

protocol RegisterCardFormViewModelViewDelegate: class {
    
}
