//
//  ReceiptsViewModel.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 10/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

class ReceiptsViewModel: ReceiptsViewModelType {
    
    weak var viewDelegate: ReceiptsViewModelViewDelegate?
 
    weak var coordinatorDelegate: ReceiptsViewModelCoordinatorDelegate?
    
    var payment: ConfirmedTransaction
    var card: CreditCard
    
    init(paymentConfirmation: ConfirmedTransaction, card: CreditCard) {
        self.payment = paymentConfirmation
        self.card = card
    }
    
    var contactUsername: String {
        return payment.transaction.destinationUser.username
    }
    
    var trasactionDate: String {
        guard let interval = TimeInterval(exactly: payment.transaction.timestamp) else {
            return TransactionDateFormatter.formatterForDate.string(from: Date())
        }
        
        let date = Date(timeIntervalSince1970: interval)
        let dateString = TransactionDateFormatter.formatterForDate.string(from: date)
        let timeString = TransactionDateFormatter.formatterForTime.string(from: date)
        return dateString + " às " + timeString
    }
    
    var trasactionId: String {
        return "Transação: \(payment.transaction.id)"
    }
    
    var cardName: String {
        let indexes = card.cardNumber.startIndex..<card.cardNumber.index(card.cardNumber.startIndex, offsetBy: 4)
        let cardNumber = String(card.cardNumber[indexes])
        return "Cartão final " + cardNumber
    }
    
    var cardPaymentValue: String {
        let paymentValueNumber = NSNumber(value: payment.transaction.value)
        guard let stringValue = PaymentFormatter.formatter.string(from: paymentValueNumber) else {
            return "R$ \(payment.transaction.value)"
        }
        return "R$ " + stringValue
    }
    
    var totalPayment: String {
        return cardPaymentValue
    }
    
    func contactImage(completion: @escaping (UIImage?) -> Void) {
        ImageDownloader(urlSession: URLSession.shared).downloadImage(from: payment.transaction.destinationUser.imageUrl) { (image, error) in
            completion(image)
        }
    }
}
