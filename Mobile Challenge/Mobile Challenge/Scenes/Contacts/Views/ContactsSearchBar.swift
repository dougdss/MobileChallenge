//
//  ContactsSearchbar.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 03/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

class ContactsSearchBar: UISearchBar {
    
    static let defaultContainerHeight: CGFloat = 56
    
    var isActive: Bool = false {
        willSet {
            newValue ? setActiveState() : setInactiveState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    private func config() {
        setSearchFieldBackgroundImage(UIImage(named: "searchBackground"), for: .normal)
        setPositionAdjustment(UIOffset(horizontal: frame.width / 12, vertical: 0), for: UISearchBar.Icon.search)
        searchTextPositionAdjustment = UIOffset(horizontal: 8, vertical: 0)
        placeholder = "A quem você deseja pagar?"
        barTintColor = .picpaySearchBarBackgroundColor
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
    
    private func setActiveState() {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        let searchImage = UIImage(named: "searchIcon")
        let closeImage = UIImage(named: "closeIcon")
        placeholder = ""
        
        setImage(searchImage, for: UISearchBar.Icon.search, state: UIControl.State.normal)
        setImage(closeImage, for: UISearchBar.Icon.clear, state: UIControl.State.normal)
        setPositionAdjustment(UIOffset(horizontal: 8, vertical: 0), for: UISearchBar.Icon.search)
    }
    
    private func setInactiveState() {
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
        placeholder = "A quem você deseja de pagar?"
        setImage(nil, for: UISearchBar.Icon.search, state: UIControl.State.normal)
        setImage(nil, for: UISearchBar.Icon.clear, state: UIControl.State.normal)
        setPositionAdjustment(UIOffset(horizontal: frame.width / 12, vertical: 0), for: UISearchBar.Icon.search)
    }
}
