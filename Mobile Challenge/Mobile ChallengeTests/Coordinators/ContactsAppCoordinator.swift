//
//  ContactsAppCoordinator.swift
//  Mobile ChallengeTests
//
//  Created by Douglas da Silva Santos on 06/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import XCTest
@testable import Mobile_Challenge

class ContactsAppCoordinatorTests: XCTestCase {

    var sut: ContactsAppCoordinator!
    let coordinatorDelegateSpy = CoordinatorDelegateSpy()
    let contactsServiceStub = ContactsServiceStub()
    let creditCardServiceStub = CreditCardServiceStub()
    
    override func setUp() {
        super.setUp()
        
        sut = ContactsAppCoordinator(window: UIWindow(frame: UIScreen.main.bounds), creditCardService: creditCardServiceStub)
        let viewModel = ContactsViewModel(service: contactsServiceStub)
        sut.contactsViewModel = viewModel
        viewModel.coordinatorDelegate = coordinatorDelegateSpy
    }
    
    func test_selectingContactInViewModelCallCoordinatorSelectContact() {
        contactsServiceStub.isSuccess = true
        sut.contactsViewModel.loadContacts()
        sut.contactsViewModel.didSelect(row: 0, from: UIViewController())
        
        XCTAssertTrue(coordinatorDelegateSpy.didSelectContatWasCalled)
    }
    
    
}


class CreditCardServiceStub: CreditCardService {
    func saveCreditCard(creditCard: CreditCard, completion: @escaping (Bool, Error?) -> Void) {
        
    }
    
    func loadSavedCard(completion: (CreditCard?, Error?) -> Void) {
        
    }
    
    func updateSavedCard(withCard card: CreditCard, completion: @escaping (Bool, Error?) -> Void) {
        
    }
    
    
}
