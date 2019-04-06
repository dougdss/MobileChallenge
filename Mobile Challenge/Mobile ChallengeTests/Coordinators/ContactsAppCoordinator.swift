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
    
    override func setUp() {
        super.setUp()
        
        sut = ContactsAppCoordinator(window: UIWindow(frame: UIScreen.main.bounds))
        sut.contactsViewModel = ContactsViewModel(service: contactsServiceStub)
        sut.contactsViewModel.coordinatorDelegate = coordinatorDelegateSpy
    }
    
    func test_selectingContactInViewModelCallCoordinatorSelectContact() {
        contactsServiceStub.isSuccess = true
        sut.contactsViewModel.loadContacts()
        sut.contactsViewModel.didSelect(row: 0, from: UIViewController())
        
        XCTAssertTrue(coordinatorDelegateSpy.didSelectContatWasCalled)
    }
    
    
}

