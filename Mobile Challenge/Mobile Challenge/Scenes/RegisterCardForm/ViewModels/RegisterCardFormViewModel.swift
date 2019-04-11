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
 
    var isUpdatingCard: Bool = false
    var cardToUpdate: CreditCard? = nil {
        didSet{
            cardNumber = cardToUpdate?.cardNumber ?? ""
            holderName = cardToUpdate?.cardHolderName ?? ""
            dueDate = cardToUpdate?.dueDate ?? Date()
            cvv = cardToUpdate?.cardCVV ?? ""
        }
    }
    
    weak var viewDelegate: RegisterCardFormViewModelViewDelegate?
    weak var coordinatorDelegate: RegisterCardFormViewModelCoordinatorDelegate?
    
    private let service: CreditCardService
    
    init(creditCardService: CreditCardService) {
        self.service = creditCardService
    }
    
    func saveCard(card: CreditCard, from controller: UIViewController) {
        service.saveCreditCard(creditCard: card) { [unowned self] (success, error) in
            if success {
                self.viewDelegate?.showSaveCardSuccess {
                    self.coordinatorDelegate?.didSaveCreditCard(creditCard: card, from: controller)
                }
            } else {
                self.viewDelegate?.showError(error: error)
            }
        }
    }
    
    func updateCard(card: CreditCard, from controller: UIViewController) {
        service.updateSavedCard(withCard: card) { [unowned self] (success, error) in
            if success {
                self.viewDelegate?.showSaveCardSuccess {
                    self.coordinatorDelegate?.didUpdateCreditCard(creditCard: card, from: controller)
                }
            } else {
                self.viewDelegate?.showError(error: error)
            }
        }
    }
    
    func formatCardNumber(cardNumber number: String) {
        
        let formattedText = CreditCardFormatter.formatCreditCard(withText: number)
        
        cardNumber = formattedText
        viewDelegate?.updateCardNumber(cardNumber: formattedText)
        validateForm()
    }
    
    func formatCardExpiryDate(cardExpiryDate date: String) {
        
        let formattedText = CreditCardFormatter.formatCreditCardExpiryDate(withText: date)
        dueDate = CardExpiryDateFormatter.formatter.date(from: formattedText) ?? Date()
        viewDelegate?.updateCardExpiryDate(expiryDate: formattedText)
        validateForm()
        
    }
    
    func formatCardCvv(cardCVV cvv: String) {
        self.cvv = cvv
        validateForm()
        
    }
    
    func formatCardHolderName(cardHolderName name: String) {
        validateForm()
        self.holderName = name
    }
    
    func validateForm() {
        var isValid = true
        
        
        isValid = cardNumber.count == 19 &&
            CardExpiryDateFormatter.formatter.string(from: dueDate).count == 5 &&
            cvv.count == 3 &&
            holderName.count >= 12
        
        viewDelegate?.isFormValid(valid: isValid)
    }
    
    
    func didTouchBackButton() {
        coordinatorDelegate?.didPopFromNavigation()
    }
}
