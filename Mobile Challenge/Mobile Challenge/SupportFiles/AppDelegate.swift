//
//  AppDelegate.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 02/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: Coordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        customizeAppearance()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = ContactsAppCoordinator(window: window)
        appCoordinator.start()
        
        return true
    }
    
    func customizeAppearance() {
        UITextField.appearance(whenContainedInInstancesOf: [ContactsSearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        
    }
}

