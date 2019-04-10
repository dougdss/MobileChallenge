//
//  PaymentViewModel.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 09/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation

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
    
    func pay() {
        if let cvv = Int(card.cardCVV) {
            
            let transactionInfo = TransactionInfo(cardNumber: card.cardNumber.replacingOccurrences(of: " ", with: ""),
                                                  cvv: cvv,
                                                  value: paymentValue.doubleValue,
                                                  expiryDate: dateFormatter.string(from: card.dueDate),
                                                  destinationUserId: contact.id)
            
            service.confirmTransaction(transaction: transactionInfo) { (result: Result<ConfirmedTransaction>) in
                switch result {
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error)
                    break
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
