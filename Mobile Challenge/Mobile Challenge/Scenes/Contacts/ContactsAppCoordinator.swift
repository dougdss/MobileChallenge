//
//  ContactsCoordinator.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 03/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

class ContactsAppCoordinator: Coordinator {
    
    var window: UIWindow?
    var rootViewController: UINavigationController {
        let controller = ContactsViewController()
        controller.viewModel = contactsViewModel
        return UINavigationController(rootViewController: controller)
    }
    
    let apiService: ApiService = {
        let api = ApiClient(urlSessionConfiguration: URLSessionConfiguration.default, completionHandlerQueue: OperationQueue.main)
        return api
    }()
    
    let creditCardService: CreditCardService
    
    lazy var contactsViewModel: ContactsViewModel = {
        let contactsService = ContactsApiService(apiService: apiService)
        let viewModel = ContactsViewModel(service: contactsService)
        viewModel.coordinatorDelegate = self
        return viewModel
    }()
    
    init(window: UIWindow?, creditCardService: CreditCardService) {
        self.window = window
        self.creditCardService = creditCardService
    }
    
    override func start() {
        guard let window = window else { return }
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    override func finish() {
        removeAllChildCoordinators()
    }
}

extension ContactsAppCoordinator: ContactsViewModelCoordinatorDelegate {
   
    func didSelect(contact: Contact, from controller: UIViewController) {

        creditCardService.loadSavedCard(completion: { (card, error) in
            if card == nil {
                // registerCard
                let registerCardCoordinator = RegisterCardCoordinator(rootViewController: controller, contact: contact)
                registerCardCoordinator.delegate = self
                addChildCoordinator(coordinator: registerCardCoordinator)
                registerCardCoordinator.start()
            } else {
                // payment
                let paymentCoordinator = PaymentCoordinator(rootViewController: controller, apiService: apiService, contact: contact, creditCard: card!)
                paymentCoordinator.delegate = self
                addChildCoordinator(coordinator: paymentCoordinator)
                paymentCoordinator.start()
            }
        })
    }
    
}

extension ContactsAppCoordinator: RegisterCardCoordinatorDelegate {
    func didFinish(from: RegisterCardCoordinator) {
        removeChildCoordinator(coordinator: from)
    }
}

extension ContactsAppCoordinator: PaymentCoordinatorDelegate {
    func didFinish(from: PaymentCoordinator) {
        removeChildCoordinator(coordinator: from)
    }
}
