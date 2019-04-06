//
//  ContactsViewControllerTests.swift
//  Mobile ChallengeTests
//
//  Created by Douglas da Silva Santos on 06/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import XCTest
@testable import Mobile_Challenge

class ContactsViewControllerTests: XCTestCase {
    
    var sut: ContactsViewController!
    let contactsViewModelSpy = ContactsViewModelSpy()
    
    override func setUp() {
        super.setUp()
        sut = ContactsViewController()
        contactsViewModelSpy.viewDelegate = sut
        sut.viewModel = contactsViewModelSpy
    }
    
    func test_loadViewLoadsContactsFromViewModel() {
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.tableView(sut.tableView, numberOfRowsInSection: 0) == 3)
    }
 
    func test_shouldReturnContactTableViewCellTypeForCellRow() {
        sut.loadViewIfNeeded()
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(cell.isKind(of: ContactTableViewCell.self))
    }
    
    func test_shoulReturnCorrectContactInformationForRow() {
        sut.loadViewIfNeeded()
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! ContactTableViewCell
        
        XCTAssertEqual(cell.nameLabel.text, "Mary")
        XCTAssertEqual(cell.usernameLabel.text, "@mary")
    }
    
    func test_searchBarStartEditingShouldSetSearchBarStateToActive() {
        
        sut.loadViewIfNeeded()
        _ = sut.tableView(sut.tableView, viewForHeaderInSection: 0)
        XCTAssertFalse(sut.searchBar!.isActive)
        
        sut.searchBarTextDidBeginEditing(sut.searchBar!)

        XCTAssertTrue(sut.searchBar!.isActive)
    }
    
    func test_searchBarEndEditingShouldSetSearchBarStateToInactiveForEmptySearchText() {
        sut.loadViewIfNeeded()
        _ = sut.tableView(sut.tableView, viewForHeaderInSection: 0)
        sut.searchBar!.isActive = true
        XCTAssertTrue(sut.searchBar!.isActive)
        
        sut.searchBar?.text = ""
        sut.searchBarTextDidEndEditing(sut.searchBar!)
        
        XCTAssertFalse(sut.searchBar!.isActive)
    }
    
    func test_searchBarTextChangeCallsViewModelSearch() {
        sut.loadViewIfNeeded()
        _ = sut.tableView(sut.tableView, viewForHeaderInSection: 0)
        
        sut.searchBar(sut.searchBar!, textDidChange: "")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) { [unowned self] in
            XCTAssertTrue(self.contactsViewModelSpy.searchForTextCalled)
        }
    }
    
    func test_searchBarSearchButtonClickedResignsSearchBarFromFirstResponder() {
        sut.loadViewIfNeeded()
        _ = sut.tableView(sut.tableView, viewForHeaderInSection: 0)
        
        sut.searchBar!.becomeFirstResponder()
        
        sut.searchBarSearchButtonClicked(sut.searchBar!)
        
        XCTAssertFalse(sut.searchBar!.isFirstResponder)
    }
    
    func test_shouldShowTableViewBackgroundErrorViewWhenViewModelReceivesError() {
        contactsViewModelSpy.shouldPresentError = true
        sut.loadViewIfNeeded()
        
        XCTAssertFalse(sut.tableView.backgroundView!.isHidden)
    }
    
    func test_shouldHideTableViewBackgroundAndCallLoadContactsWhenTappingErrorViewTryAgainButton() {
        contactsViewModelSpy.shouldPresentError = true
        sut.loadViewIfNeeded()
        
        XCTAssertFalse(sut.tableView.backgroundView!.isHidden)
        
        contactsViewModelSpy.shouldPresentError = false
        sut.didTapTryAgainButton(erroView: (sut.tableView.backgroundView as! ContactsErrorView))
        
        XCTAssertTrue(sut.tableView.backgroundView!.isHidden)
        XCTAssertTrue(contactsViewModelSpy.loadContactsCalled)
        
    }
    
}

class ContactsViewModelSpy: ContactsViewModelType {
    var viewDelegate: ContactsViewModelViewDelegate?
    
    func numbersOfitems() -> Int {
        return 3
    }
    
    func itemFor(row: Int) -> ContactViewDataType {
        return ContactViewData(contact: Contact(id: 1, name: "Mary", imageUrl: "http://some", username: "@mary"))
    }
    
    var shouldPresentError = false
    var loadContactsCalled = false
    func loadContacts() {
        if shouldPresentError {
            viewDelegate?.showError(error: NetworkError(error: nil))
        } else {
            loadContactsCalled = true
            viewDelegate?.updateScreen()
        }
    }
    
    var searchForTextCalled = false
    func searchFor(text: String) {
        searchForTextCalled = true
    }
    
    func didSelect(row: Int, from controller: UIViewController) {
        
    }
    
    
}
