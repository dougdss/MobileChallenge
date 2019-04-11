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
    
    var isUpdatingCard: Bool { get set }
    var cardToUpdate: CreditCard? { get set }
    func saveCard(card: CreditCard, from controller: UIViewController)
    func updateCard(card: CreditCard, from controller: UIViewController)
    func didTouchBackButton()
}

protocol RegisterCardFormViewModelCoordinatorDelegate:class {
    func didSaveCreditCard(creditCard: CreditCard, from controller: UIViewController)
    func didUpdateCreditCard(creditCard: CreditCard, from controller: UIViewController)
    func didPopFromNavigation()
}


protocol RegisterCardFormViewModelViewDelegate: class {
    func showError(error : Error?)
}
