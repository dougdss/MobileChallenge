//
//  PaymentViewModelType.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 09/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

protocol PaymentViewModelType {
    
    var viewDelegate: PaymentViewModelViewDelegate? { get set }
    
    var paymentDestinationUsername: String { get }
    var paymentCardName: String { get }
    
    func formatPaymentValue(textValue text: String)
    var paymentValue: NSNumber { get set }
    func pay(fromController controller: UIViewController)
    func editCard(fromController controller: UIViewController)
    func getUserImage(completion: @escaping (_ image: UIImage?) -> Void)
    
}

protocol PaymentViewModelCoordinatorDelegate:class {
    func didConfirm(transaction: ConfirmedTransaction, forContact contact: Contact, withCard card: CreditCard, fromController controller: UIViewController)
    func didTryToEditCard(card: CreditCard, fromController controller: UIViewController)
}

protocol PaymentViewModelViewDelegate:class {
    func updateState(state: ViewState)
    func updatePaymentValueWith(formattedText text: String, andRawText: String)
    func validateForm(isValid: Bool)
    func showError(error: Error?)
    func updateViews()
}
