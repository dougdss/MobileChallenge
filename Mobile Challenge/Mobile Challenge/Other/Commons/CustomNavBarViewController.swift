//
//  CustomNavBarViewController.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 07/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

class CustomNavBarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
    }
    
    private func configNavigationBar() {
        view.backgroundColor = .picpayDefaultBlackBackgroundColor
        navigationController?.navigationBar.barTintColor = .picpayDefaultBlackBackgroundColor
        navigationController?.navigationBar.tintColor = .picpayDefaultGreenActionColor
//        navigationController?.navigationBar.backgroundColor = .picpayDefaultBlackBackgroundColor
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barStyle = .blackOpaque
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let back = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = back
    }

    
}
