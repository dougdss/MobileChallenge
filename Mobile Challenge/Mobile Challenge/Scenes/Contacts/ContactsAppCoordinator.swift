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
    
    lazy var contactsViewModel: ContactsViewModel = {
        let contactsService = ContactsApiService(apiService: apiService)
        let viewModel = ContactsViewModel(service: contactsService)
        viewModel.coordinatorDelegate = self
        return viewModel
    }()
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    override func start() {
        guard let window = window else { return }
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}

extension ContactsAppCoordinator: ContactsViewModelCoordinatorDelegate {
   
    func didSelect(contact: Contact, from controller: UIViewController) {
        removeAllChildCoordinators()
        let registerCardCoordinator = RegisterCardCoordinator(rootViewController: controller, contact: contact)
        addChildCoordinator(coordinator: registerCardCoordinator)
        registerCardCoordinator.start()
    }
    
    
}
