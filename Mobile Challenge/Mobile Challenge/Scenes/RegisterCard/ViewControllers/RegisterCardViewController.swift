//
//  RegisterCardViewController.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 07/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

class RegisterCardViewController: CustomNavBarViewController {

    
    var viewModel: RegisterCardViewModelType! {
        didSet {
            viewModel.viewDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapRegister(_ sender: Any) {
        viewModel.didTouchRegisterCard(from: self)
    }
    
}

extension RegisterCardViewController: RegisterCardViewModelViewDelegate {
    
}
