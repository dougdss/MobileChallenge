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
    
    lazy var contactsViewModel: ContactsViewModelType = {
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

// Register Card
extension ContactsAppCoordinator: RegisterCardCoordinatorDelegate {
    func didFinish(from: RegisterCardCoordinator) {
        removeChildCoordinator(coordinator: from)
    }
    
}

// Payment
extension ContactsAppCoordinator: PaymentCoordinatorDelegate {
    
    func didFinish(from: PaymentCoordinator) {
        removeChildCoordinator(coordinator: from)
    }
    
    func didConfirmPayment(forContact contact: Contact, paymentInfo payment: ConfirmedTransaction, card: CreditCard, fromController controller: UIViewController) {
        let receiptCoordinator = ReceiptsCoordinator(rootViewController: controller, paymentConfirmation: payment, card: card)
        receiptCoordinator.delegate = self
        addChildCoordinator(coordinator: receiptCoordinator)
        receiptCoordinator.start()
    }
    
}

// Receipt
extension ContactsAppCoordinator: ReceiptsCoordinatorDelegate {
    func didFinish(fromCoordinator coordinator: ReceiptsCoordinator) {
        removeChildCoordinator(coordinator: coordinator)
    }
}
