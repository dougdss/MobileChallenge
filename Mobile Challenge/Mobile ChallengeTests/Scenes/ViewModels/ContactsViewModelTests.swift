//
//  ContactsViewModelTests.swift
//  Mobile ChallengeTests
//
//  Created by Douglas da Silva Santos on 06/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import XCTest
@testable import Mobile_Challenge

class ContactsViewModelTests: XCTestCase {

    var sut: ContactsViewModel!
    let contactsServiceStub = ContactsServiceStub()
    let coordinatorDelegateSpy = CoordinatorDelegateSpy()
    
    override func setUp() {
        super.setUp()
        sut = ContactsViewModel(service: contactsServiceStub)
    }
    
    func test_successLoadingContactsFromServiceIncreaseNumberOfContacts() {
        contactsServiceStub.isSuccess = true
        sut.loadContacts()
     
        XCTAssertTrue(sut.numbersOfitems() > 0 )
    }
    
    func test_failLoadingContactsFromServiceDontIncreaseNumberOfContacts() {
        contactsServiceStub.isSuccess = false
        sut.loadContacts()

        XCTAssertTrue(sut.numbersOfitems() == 0)
    }
    
    func test_searchForContactsReturnsContactsInFilterCondition() {
        contactsServiceStub.isSuccess = true
        sut.loadContacts()
        
        sut.searchFor(text: "j")
        XCTAssertTrue(sut.numbersOfitems() == 1)
    }
    
    func test_searchForUserWithNameJohnReturnJohnFromUsers() {
        contactsServiceStub.isSuccess = true
        sut.loadContacts()
        
        sut.searchFor(text: "john")
        XCTAssertTrue(sut.numbersOfitems() == 1)
        XCTAssertEqual(sut.itemFor(row: 0).name, "John")
    }
    
    func test_searchWithEmptyStringDoesNotChangeNumberOfContacts() {
        contactsServiceStub.isSuccess = true
        sut.loadContacts()
        
        sut.searchFor(text: "")
        XCTAssertTrue(sut.numbersOfitems() == 3)
        XCTAssertEqual(sut.itemFor(row: 0).name, "Mary")
    }
 
    func test_selectContactShouldCallCoordinatorWithSelectedContact() {
        contactsServiceStub.isSuccess = true
        sut.coordinatorDelegate = coordinatorDelegateSpy
        sut.loadContacts()
        
        sut.didSelect(row: 0, from: UIViewController())
        
        XCTAssertTrue(coordinatorDelegateSpy.didSelectContatWasCalled)
        XCTAssertEqual(coordinatorDelegateSpy.selectedContact?.name, "Mary")
    }
    
    func test_selectContactWithFilterShouldCallCoordinatorWithSelectedContact() {
        contactsServiceStub.isSuccess = true
        sut.coordinatorDelegate = coordinatorDelegateSpy
        sut.loadContacts()
        
        sut.searchFor(text: "esteban")
        sut.didSelect(row: 0, from: UIViewController())
        
        XCTAssertTrue(coordinatorDelegateSpy.didSelectContatWasCalled)
        XCTAssertEqual(coordinatorDelegateSpy.selectedContact?.name, "Esteban")
    }
}

class ContactsServiceStub: ContactsService {
    
    var isSuccess = false
    
    func getContacts(completion: @escaping (Result<[Contact]>) -> Void) {
        if isSuccess {
            completion(successContactsResult())
        } else {
            completion(.failure(NetworkError(error: nil)))
        }
    }
    
    private func successContactsResult() -> Result<[Contact]> {
        return Result.success(contacts())
    }
    
    private func contacts() -> [Contact] {
        let contact = Contact(id: 1, name: "Mary", imageUrl: "http://some", username: "@mary")
        let contact2 = Contact(id: 2, name: "John", imageUrl: "http://some", username: "@john")
        let contact3 = Contact(id: 3, name: "Esteban", imageUrl: "http://some", username: "@esteban")
        return [contact, contact2, contact3]
    }
    
}

class CoordinatorDelegateSpy: ContactsViewModelCoordinatorDelegate {
    
    var didSelectContatWasCalled = false
    var selectedContact: Contact?
    func didSelect(contact: Contact, from controller: UIViewController) {
        didSelectContatWasCalled = true
        selectedContact = contact
    }
    
}
