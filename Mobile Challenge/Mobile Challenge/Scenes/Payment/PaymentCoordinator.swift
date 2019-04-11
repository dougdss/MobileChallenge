//
//  PyamentCoordinator.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 09/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

protocol PaymentCoordinatorDelegate:class {
    func didFinish(from: PaymentCoordinator)
    func didConfirmPayment(forContact contact: Contact, paymentInfo payment: ConfirmedTransaction, card: CreditCard, fromController controller: UIViewController)
}

class PaymentCoordinator: Coordinator {
    
    var rootViewController: UIViewController
    var apiService: ApiService
    var contact: Contact
    var creditCard: CreditCard
    
    weak var delegate: PaymentCoordinatorDelegate?
    
    var viewModel: PaymentViewModelType {
        let service = PaymentApiService(apiService: apiService)
        let viewModel = PaymentViewModel(service: service, card: creditCard, contact: contact)
        viewModel.coordinatorDelegate = self
        return viewModel
    }
    
    init(rootViewController: UIViewController, apiService: ApiService, contact: Contact, creditCard: CreditCard) {
        self.rootViewController = rootViewController
        self.apiService = apiService
        self.contact = contact
        self.creditCard = creditCard
    }
    
    override func start() {
        let paymentVC = PaymentViewController()
        paymentVC.viewModel = viewModel
        
        rootViewController.navigationController?.pushViewController(paymentVC, animated: true)
    }
    
    override func finish() {
        delegate?.didFinish(from: self)
    }
    
}

extension PaymentCoordinator: PaymentViewModelCoordinatorDelegate {
    
    func didConfirm(transaction: ConfirmedTransaction, forContact contact: Contact, withCard card: CreditCard, fromController controller: UIViewController) {
        rootViewController.navigationController?.popViewController(animated: true)
        finish()
        delegate?.didConfirmPayment(forContact: contact, paymentInfo: transaction, card: card, fromController: controller)
    }
    
    func didTryToEditCard(card: CreditCard, fromController controller: UIViewController) {
        //show registrationVC
        let registerCardFormCoordinator = RegisterCardFormCoordinator(rootViewController: rootViewController, contact: contact)
        registerCardFormCoordinator.cardToUpdate = card
        registerCardFormCoordinator.delegate = self
        addChildCoordinator(coordinator: registerCardFormCoordinator)
        registerCardFormCoordinator.start()
    }
}

extension PaymentCoordinator: RegisterCardFormCoordinatorDelegate {
    
    func didFinish(from: RegisterCardFormCoordinator) {
        removeChildCoordinator(coordinator: from)
    }
    
    func didUpdateCard(creditCard newCard: CreditCard, fromController controller: UIViewController) {
        creditCard = newCard
        (rootViewController.navigationController?.topViewController as? PaymentViewController)?.viewModel = viewModel
        viewModel.viewDelegate?.updateViews()
    }
}
