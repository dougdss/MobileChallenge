//
//  RegisterCardCoordinator.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 07/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

class RegisterCardCoordinator: Coordinator {
    
    var rootViewController: UIViewController
    var selectedContact: Contact
    
    init(rootViewController: UIViewController, contact: Contact) {
        self.rootViewController = rootViewController
        self.selectedContact = contact
    }
    
    override func start() {
        let registerCardVC = RegisterCardViewController()
//        registerCardVC.viewModel = viewmodel
        rootViewController.navigationController?.pushViewController(registerCardVC, animated: true)
//        rootViewController.present(registerCardVC, animated: true, completion: nil)
    }
    
}
