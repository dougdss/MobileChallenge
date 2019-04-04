//
//  AppCoordinator.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 03/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var window: UIWindow?
    var rootViewController: UINavigationController {
        return UINavigationController()
    }
    
    let apiService: ApiService = {
        let api = ApiClient(urlSessionConfiguration: URLSessionConfiguration.default, completionHandlerQueue: OperationQueue.main)
        return api
    }()
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    override func start() {
        guard let window = window else {
            return
        }
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
}
