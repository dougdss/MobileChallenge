//
//  BaseNavigationControllerChild.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 04/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

class BaseNavigationControllerChild: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInitialConfiguration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func viewInitialConfiguration() {
        view.backgroundColor = .picpayDefaultBlackBackground
        navigationController?.navigationBar.barTintColor = .picpayDefaultBlackBackground
        navigationController?.navigationBar.backgroundColor = .picpayDefaultBlackBackground
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barStyle = .blackOpaque
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

