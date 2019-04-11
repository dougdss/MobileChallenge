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
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapRegister(_ sender: Any) {
        viewModel.didTouchRegisterCard(from: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            viewModel.didTouchBackButton()
        }
    }
    
}

extension RegisterCardViewController: RegisterCardViewModelViewDelegate {
    
}
