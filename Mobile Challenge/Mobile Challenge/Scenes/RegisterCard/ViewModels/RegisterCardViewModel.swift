//
//  RegisterCardViewModel.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 07/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

class RegisterCardViewModel: RegisterCardViewModelType {
    
    weak var viewDelegate: RegisterCardViewModelViewDelegate?
    
    weak var coordinatorDelegate: RegisterCardViewModelCoordinatorDelegate?
    
    var contact: Contact
    
    init(contact: Contact) {
        self.contact = contact
    }

    func didTouchRegisterCard(from controller: UIViewController) {
        coordinatorDelegate?.didSelectRegister(withContact: contact, from: controller)
    }
    
    func didGoBack() {
        coordinatorDelegate?.didCallPop()
    }
    
}
