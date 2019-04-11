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
 
    @IBOutlet var contentView: UIView!
    
    weak var delegate: ContactsErrorViewDelegate?
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    @IBAction func tryAgainButtonTapped(_ sender: Any) {
        delegate?.didTapTryAgainButton(erroView: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ContactsErrorView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
