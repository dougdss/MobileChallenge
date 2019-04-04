//
//  ContactsViewModelType.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 04/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

protocol ContactsViewModelType {
 
    var viewDelegate: ContactsViewModelViewDelegate? { get set }
 
    func numbersOfitems() -> Int
    func itemFor(row: Int) -> ContactViewDataType
    
    func loadContacts()
    func searchFor(text: String)
    func didSelect(row: Int, from controller: UIViewController)

    
}

protocol ContactsViewModelCoordinatorDelegate: class {
    
    func didSelect(contact: Contact, from controller: UIViewController)
    
}

protocol ContactsViewModelViewDelegate: class {
    
    func updateScreen()
    
    func updateState(_ state: ViewState)
    
    func showError(error: Error)
}
