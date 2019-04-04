//
//  ContactsErrorView.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 04/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

protocol ContactsErrorViewDelegate: class {
    func didTapTryAgainButton(erroView: ContactsErrorView)
}

class ContactsErrorView: UIView {
 
    weak var delegate: ContactsErrorViewDelegate?
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    @IBAction func tryAgainButtonTapped(_ sender: Any) {
        delegate?.didTapTryAgainButton(erroView: self)
    }
    
    
}
