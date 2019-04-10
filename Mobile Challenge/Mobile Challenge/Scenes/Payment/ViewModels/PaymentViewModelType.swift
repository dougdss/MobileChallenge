//
//  PaymentViewModelType.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 09/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation

protocol PaymentViewModelType {
    
    var viewDelegate: PaymentViewModelViewDelegate? { get set }
    
    func formatPaymentValue(textValue text: String)
    
    var paymentValue: NSNumber { get set }
    var paymentFormatter: NumberFormatter { get }
    var dateFormatter: DateFormatter { get }
    func pay()
}

protocol PaymentViewModelCoordinatorDelegate:class {
    func didPay(value: Double, forContact: Contact)
}

protocol PaymentViewModelViewDelegate:class {
    func updateState(state: ViewState)
    func updatePaymentValueWith(formattedText text: String, andRawText: String)
    func validateForm(isValid: Bool)
}
