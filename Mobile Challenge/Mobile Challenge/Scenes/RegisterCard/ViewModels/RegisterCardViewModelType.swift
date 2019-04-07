//
//  RegisterCardViewModel.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 07/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

protocol RegisterCardViewModelType {
    
    var viewDelegate: RegisterCardViewModelViewDelegate? { get set }
    
    var contact: Contact { get set }
    
    func didTouchRegisterCard(from controller: UIViewController)
}

protocol RegisterCardViewModelCoordinatorDelegate: class {
    
    func didSelectRegister(withContact: Contact, from controller: UIViewController)
    
}

protocol RegisterCardViewModelViewDelegate: class {
    
}
