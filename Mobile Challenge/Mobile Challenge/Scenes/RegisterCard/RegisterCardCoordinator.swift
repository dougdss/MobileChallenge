//
//  RegisterCardCoordinator.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 07/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

protocol RegisterCardCoordinatorDelegate:class {
    func didFinish(from: RegisterCardCoordinator)
}

class RegisterCardCoordinator: Coordinator {
    
    var rootViewController: UIViewController
    var selectedContact: Contact
    weak var delegate: RegisterCardCoordinatorDelegate?
    
    init(rootViewController: UIViewController, contact: Contact) {
        self.rootViewController = rootViewController
        self.selectedContact = contact
    }
    
    override func start() {
        let registerCardVC = RegisterCardViewController()
        let viewModel = RegisterCardViewModel(contact: selectedContact)
        viewModel.coordinatorDelegate = self
        registerCardVC.viewModel = viewModel
        rootViewController.navigationController?.pushViewController(registerCardVC, animated: true)
    }
    
    override func finish() {
        delegate?.didFinish(from: self)
    }
    
}

extension RegisterCardCoordinator: RegisterCardViewModelCoordinatorDelegate {
    
    func didSelectRegister(withContact: Contact, from controller: UIViewController) {
        let registerCardFormCoordinator = RegisterCardFormCoordinator(rootViewController: rootViewController, contact: withContact)
        registerCardFormCoordinator.delegate = self
        addChildCoordinator(coordinator: registerCardFormCoordinator)
        registerCardFormCoordinator.start()
    }
    
    func didPopFromNavigation() {
        finish()
    }
    
}

extension RegisterCardCoordinator: RegisterCardFormCoordinatorDelegate {
    
    func didFinish(from: RegisterCardFormCoordinator) {
        removeChildCoordinator(coordinator: from)
    }
}
