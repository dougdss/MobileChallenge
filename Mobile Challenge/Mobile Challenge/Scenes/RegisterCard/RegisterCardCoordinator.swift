//
//  RegisterCardCoordinator.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 07/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

protocol RegisterCardCoordinatorDelegate {
    func didFinish()
    func didFinishAfterSave()
}

class RegisterCardCoordinator: Coordinator {
    
    var rootViewController: UIViewController
    var selectedContact: Contact
    var delegate: RegisterCardCoordinatorDelegate?
    
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
        removeAllChildCoordinators()
    }
    
}

extension RegisterCardCoordinator: RegisterCardViewModelCoordinatorDelegate {
    
    func didSelectRegister(withContact: Contact, from controller: UIViewController) {
        let registerCardFormCoordinator = RegisterCardFormCoordinator(rootViewController: rootViewController, contact: withContact)
        registerCardFormCoordinator.delegate = self
        addChildCoordinator(coordinator: registerCardFormCoordinator)
        registerCardFormCoordinator.start()
    }

    func didCallPop() {
        delegate?.didFinish()
    }
    
}

extension RegisterCardCoordinator: RegisterCardFormCoordinatorDelegate {
    func didPopFromForm() {
        removeAllChildCoordinators()
    }
    
    func didFinishAfterSave() {
        delegate?.didFinishAfterSave()
    }
}
