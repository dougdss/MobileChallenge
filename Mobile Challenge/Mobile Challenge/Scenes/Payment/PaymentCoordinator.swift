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
    
    func didPay(value: Double, forContact: Contact) {
        
    }
}
