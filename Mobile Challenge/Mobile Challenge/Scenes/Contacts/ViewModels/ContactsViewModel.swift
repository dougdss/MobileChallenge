//
//  ContactsViewModel.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 04/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

class ContactsViewModel {
    
    //delegates
    
    weak var coordinatorDelegate: ContactsViewModelCoordinatorDelegate?
    
    weak var viewDelegate: ContactsViewModelViewDelegate?
    
    //properties
    
    fileprivate let service: ContactsService
    
    fileprivate var contacts: [Contact] = []
    
    fileprivate var filteredContacts: [Contact] = []
    
    fileprivate var isSearching: Bool = false
    
    //init
    
    init(service: ContactsService) {
        self.service = service
    }

    func loadContacts() {
        getContacts()
    }
    
    // networking
    
    private func getContacts() {
        viewDelegate?.updateState(.loading)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.service.getContacts { (result: Result<[Contact]>) in
                self.viewDelegate?.updateState(.loaded)
                switch result {
                case .success(let contacts):
                    self.contacts = contacts
                    self.viewDelegate?.updateScreen()
                case .failure(let error):
                    self.viewDelegate?.showError(error: error)
                }
            }
        }
        
    }
    
    private func getFilteredContacts(searchText: String) {
        
        //Simple Filter for contacts
        let filter = contacts.filter { (contact: Contact) -> Bool in
            return  contact.name.lowercased().contains(searchText.lowercased()) ||
                contact.username.lowercased().contains(searchText.lowercased())
        }
        
        filteredContacts = filter
        viewDelegate?.updateScreen()
        viewDelegate?.updateState(.loaded)
    }
    
}

extension ContactsViewModel: ContactsViewModelType {
    
    func numbersOfitems() -> Int {
        return isSearching ? filteredContacts.count : contacts.count
    }
    
    func itemFor(row: Int) -> ContactViewDataType {
        let contact = isSearching ? filteredContacts[row] : contacts[row]
        return ContactViewData(contact: contact)
    }
    
    func searchFor(text: String) {
        guard !text.isEmpty else {
            isSearching = false
            viewDelegate?.updateScreen()
            return
        }
        
        filteredContacts = []
        viewDelegate?.updateState(.loading)
        
        isSearching = true
        getFilteredContacts(searchText: text)
    }
    
    func didSelect(row: Int, from controller: UIViewController) {
        let contact = isSearching ? filteredContacts[row] : contacts[row]
        coordinatorDelegate?.didSelect(contact: contact, from: controller)
    }
    
}
