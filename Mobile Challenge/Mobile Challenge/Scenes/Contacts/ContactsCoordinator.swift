//
//  ContactsCoordinator.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 03/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

class ContactsCoordinator: AppCoordinator {
    
    var window: UIWindow?
    var rootViewController: UIViewController {
        return UINavigationController(rootViewController: ContactsViewController())
    }
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        guard let window = window else { return }
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
