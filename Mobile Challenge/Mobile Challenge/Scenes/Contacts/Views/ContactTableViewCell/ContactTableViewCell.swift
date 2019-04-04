//
//  ContactTableViewCell.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 04/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    static let identifier: String = "ContactTableViewCell"
    static let estimatedRowHeight: CGFloat = 80
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configWithViewData(viewData: ContactViewDataType) {
        usernameLabel.text = viewData.username
        nameLabel.text = viewData.name
    }
    
}
