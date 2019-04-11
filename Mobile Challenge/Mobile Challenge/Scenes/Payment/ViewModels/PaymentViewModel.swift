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
    var card: CreditCard
    let contact: Contact
    
    init(service: PaymentService, card: CreditCard, contact: Contact) {
        self.service = service
        self.contact = contact
        self.card = card
    }
    
    var paymentValue: NSNumber = NSNumber(value: 0)
    
    func formatPaymentValue(textValue text: String) {
        guard let numberValue = PaymentFormatter.formatter.number(from: text) else {
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

        if let str = PaymentFormatter.formatter.string(from: NSNumber(value: paymentValue.doubleValue)) {
            viewDelegate?.updatePaymentValueWith(formattedText: str, andRawText: text)
            viewDelegate?.validateForm(isValid: paymentValue.doubleValue  >= 10.0)
        }
    }
    
    func pay(fromController controller: UIViewController) {
        if let cvv = Int(card.cardCVV) {
            let transactionInfo = TransactionInfo(cardNumber: card.cardNumber.replacingOccurrences(of: " ", with: ""),
                                                  cvv: cvv,
                                                  value: paymentValue.doubleValue,
                                                  expiryDate: CardExpiryDateFormatter.formatter.string(from: card.dueDate),
                                                  destinationUserId: contact.id)
            viewDelegate?.updateState(state: .loading)
            service.confirmTransaction(transaction: transactionInfo) { [unowned self] (result: Result<ConfirmedTransaction>) in
                self.viewDelegate?.updateState(state: .loaded)
                switch result {
                case .success(let value):
                    if value.transaction.success && value.transaction.status != "Recusada"{
                        self.coordinatorDelegate?.didConfirm(transaction: value, forContact: self.contact, withCard: self.card, fromController: controller)
                    } else {
                        self.viewDelegate?.showError(error: TransactionError.rejected)
                    }
                case .failure(let error):
                    self.viewDelegate?.showError(error: error)
                }
            }
        }
    }
    
    func editCard(fromController controller: UIViewController) {
        coordinatorDelegate?.didTryToEditCard(card: card, fromController: controller)
    }

    var paymentDestinationUsername: String {
        return contact.username
    }
    
    var paymentCardName: String {
        let indexes = card.cardNumber.index(card.cardNumber.endIndex, offsetBy: -4)..<card.cardNumber.endIndex
        let cardNumber = String(card.cardNumber[indexes])
        return "Cartão final " + cardNumber
    }
    
    func getUserImage(completion: @escaping (UIImage?) -> Void) {
        ImageDownloader(urlSession: URLSession.shared).downloadImage(from: contact.imageUrl) { (image, error) in
            //ignore error
            completion(image)
        }
    }
        
}
