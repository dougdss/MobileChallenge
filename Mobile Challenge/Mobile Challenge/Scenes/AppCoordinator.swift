//
//  AppCoordinator.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 03/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

protocol AppCoordinator: Coordinator {
    
    var window: UIWindow? { set get }
    var rootViewController: UIViewController { get }
    
}

