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
    @IBOutlet weak var userImageView: UIImageView!
    
    func configWithViewData(viewData: ContactViewDataType) {
        usernameLabel.text = viewData.username
        nameLabel.text = viewData.name
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.layer.masksToBounds = true
        userImageView.contentMode = .scaleAspectFit
        
        guard let urlString = viewData.userImageUrl else { return }
        ImageDownloader().downloadImage(from: urlString) { [unowned self] (image, error) in
            if let userImage = image {
                DispatchQueue.main.async {
                    self.userImageView.image = userImage
                }
            }
        }
    }
    
}
