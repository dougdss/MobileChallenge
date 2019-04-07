//
//  RegisterCardFormViewController.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 07/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

class RegisterCardFormViewController: CustomNavBarViewController {

    var viewModel: RegisterCardFormViewModelType! {
        didSet {
            viewModel.viewDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension RegisterCardFormViewController: RegisterCardFormViewModelViewDelegate {
    
}
