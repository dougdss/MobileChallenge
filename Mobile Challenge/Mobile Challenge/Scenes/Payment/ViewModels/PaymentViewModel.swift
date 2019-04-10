//
//  PaymentViewModel.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 09/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

class PaymentViewModel: PaymentViewModelType {
    
    weak var viewDelegate: PaymentViewModelViewDelegate?
    
    weak var coordinatorDelegate: PaymentViewModelCoordinatorDelegate?
    
    let service: PaymentService
    let card: CreditCard
    let contact: Contact
    
    init(service: PaymentService, card: CreditCard, contact: Contact) {
        self.service = service
        self.contact = contact
        self.card = card
    }
    
    var paymentValue: NSNumber = NSNumber(value: 0)
    
    func formatPaymentValue(textValue text: String) {
        guard let numberValue = paymentFormatter.number(from: text) else {
            viewDelegate?.updatePaymentValueWith(formattedText: "0,00", andRawText: "")
            viewDelegate?.validateForm(isValid: paymentValue.doubleValue >= 10.0)
            return
        }
        
        paymentValue = NSNumber(value: numberValue.doubleValue / 100)

        if paymentValue.doubleValue == 0 {
            viewDelegate?.updatePaymentValueWith(formattedText: "0,00", andRawText: "")
            viewDelegate?.validateForm(isValid: paymentValue.doubleValue  >= 10.0)
            return
        }

        if let str = paymentFormatter.string(from: NSNumber(value: paymentValue.doubleValue)) {
            viewDelegate?.updatePaymentValueWith(formattedText: str, andRawText: text)
            viewDelegate?.validateForm(isValid: paymentValue.doubleValue  >= 10.0)
        }
    }
    
    func pay(fromController controller: UIViewController) {
        if let cvv = Int(card.cardCVV) {
            let transactionInfo = TransactionInfo(cardNumber: card.cardNumber.replacingOccurrences(of: " ", with: ""),
                                                  cvv: cvv,
                                                  value: paymentValue.doubleValue,
                                                  expiryDate: dateFormatter.string(from: card.dueDate),
                                                  destinationUserId: contact.id)
            viewDelegate?.updateState(state: .loading)
            service.confirmTransaction(transaction: transactionInfo) { [unowned self] (result: Result<ConfirmedTransaction>) in
                self.viewDelegate?.updateState(state: .loaded)
                switch result {
                case .success(let value):
                    self.coordinatorDelegate?.didConfirm(transaction: value, forContact: self.contact, fromController: controller)
                case .failure(let error):
//                    let confirm = ConfirmedTransaction(transaction: ConfirmedTransaction.Transaction.init(success: true, status: "Aprovado", id: 1, timestamp: 123123123, value: 100.0, destinationUser: self.contact))
//                    self.coordinatorDelegate?.didConfirm(transaction: confirm, forContact: self.contact, fromController: controller)
                    self.viewDelegate?.showError(error: error)
                }
            }
        }
    }

    
    var paymentFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.locale = Locale(identifier: "pt-BR")
        return formatter
    }
    
    var dateFormatter: DateFormatter {
        let form = DateFormatter()
        form.dateFormat = "MM/yy"
        form.locale = Locale(identifier: "pt-BR")
        return form
    }
    
}
