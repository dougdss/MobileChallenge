//
//  RegisterCardFormCoordinator.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 07/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

protocol RegisterCardFormCoordinatorDelegate:class  {
    func didFinish(from: RegisterCardFormCoordinator)
    func didUpdateCard(creditCard newCard:CreditCard, fromController controller: UIViewController)
}

class RegisterCardFormCoordinator: Coordinator {
    
    var rootViewController: UIViewController
    var selectedContact: Contact
    weak var delegate: RegisterCardFormCoordinatorDelegate?
    var cardToUpdate: CreditCard?
    
    init(rootViewController: UIViewController, contact: Contact) {
        self.rootViewController = rootViewController
        self.selectedContact = contact
    }
    
    lazy var registerCardFormViewModel: RegisterCardFormViewModelType = {
        let viewModel = RegisterCardFormViewModel(creditCardService: CreditCardCoreDataService.defaultService)
        viewModel.cardToUpdate = cardToUpdate
        viewModel.isUpdatingCard = cardToUpdate != nil
        viewModel.coordinatorDelegate = self
        return viewModel
    }()
    
    override func start() {
        let registerCardFormVC = RegisterCardFormViewController()
        registerCardFormVC.viewModel = registerCardFormViewModel
        rootViewController.navigationController?.pushViewController(registerCardFormVC, animated: true)
    }
    
    override func finish() {
        delegate?.didFinish(from: self)
    }
    
}

extension RegisterCardFormCoordinator: RegisterCardFormViewModelCoordinatorDelegate {
    
    func didSaveCreditCard(creditCard: CreditCard, from controller: UIViewController) {
        guard let rootController = rootViewController.navigationController?.viewControllers.first else {
            return
        }
        
        rootViewController.navigationController?.setViewControllers([rootController], animated: true)
    }
    
    func didUpdateCreditCard(creditCard: CreditCard, from controller: UIViewController) {
        rootViewController.navigationController?.popViewController(animated: true)
        delegate?.didUpdateCard(creditCard: creditCard, fromController: controller)
    }
    
    func didPopFromNavigation() {
        finish()
    }
}
