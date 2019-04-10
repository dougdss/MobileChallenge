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
}

class RegisterCardFormCoordinator: Coordinator {
    
    var rootViewController: UIViewController
    var selectedContact: Contact
    weak var delegate: RegisterCardFormCoordinatorDelegate?
    
    init(rootViewController: UIViewController, contact: Contact) {
        self.rootViewController = rootViewController
        self.selectedContact = contact
    }
    
    lazy var registerCardFormViewModel: RegisterCardFormViewModel = {
        let manager = CoreDataManager(modelName: "Cards")
        let service = CreditCardCoreDataService(dataManager: manager)
        let viewModel = RegisterCardFormViewModel(creditCardService: service)
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
    
    func didPopFromNavigation() {
        finish()
    }
}
