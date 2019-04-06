//
//  ContactsViewController.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 03/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var searchBar: ContactsSearchBar?
    
    var viewModel: ContactsViewModelType! {
        didSet {
            viewModel.viewDelegate = self
        }
    }
    
    //constants
    let defaultTopContentInset: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        viewModel.loadContacts()
    }
    
    private func setupViews() {
        self.title = "Contatos"
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .picpayDefaultBlackBackground
        
        configTableView()
        configBackgroundView()
    }
    
    private func configTableView() {
        tableView.contentInset.top = defaultTopContentInset
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ContactsSearchBarTableHeaderView.identifier, bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: ContactsSearchBarTableHeaderView.identifier)
        tableView.register(UINib(nibName: ContactTableViewCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: ContactTableViewCell.identifier)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        tableView.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(gesture: UITapGestureRecognizer) {
        searchBar?.resignFirstResponder()
    }
    
    private func configBackgroundView() {
        let errorView = ContactsErrorView()
        errorView.delegate = self
        tableView.backgroundView = errorView
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension ContactsViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        (searchBar as! ContactsSearchBar).isActive = true
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.tableView.contentInset.top = 0
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            (searchBar as! ContactsSearchBar).isActive = false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

extension ContactsViewController: ContactsViewModelViewDelegate {
    func updateScreen() {
        tableView.reloadData()
    }
    
    func updateState(_ state: ViewState) {
        switch state {
        case .loading:
            indicator.startAnimating()
        case .loaded:
            indicator.stopAnimating()
        }
    }
    
    func showError(error: Error) {
        tableView.backgroundView?.isHidden = false
    }
    
}

extension ContactsViewController: ContactsErrorViewDelegate {
    
    func didTapTryAgainButton(erroView: ContactsErrorView) {
        tableView.backgroundView?.isHidden = true
        viewModel.loadContacts()
    }
    
}

extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return ContactTableViewCell.estimatedRowHeight + 20
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return ContactTableViewCell.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numbersOfitems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewdata = viewModel.itemFor(row: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as! ContactTableViewCell
        cell.configWithViewData(viewData: viewdata,isFirstRow: indexPath.row == 0)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let searchHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: ContactsSearchBarTableHeaderView.identifier) as! ContactsSearchBarTableHeaderView
        searchBar = searchHeader.searchBar
        searchBar?.delegate = self
        return searchHeader
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ContactsSearchBar.defaultContainerHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // verify and set the new offset for tableView
        let offset = scrollView.contentOffset.y
        if offset < -defaultTopContentInset {
            tableView.contentInset.top = defaultTopContentInset
        } else if offset >= -defaultTopContentInset && offset <= 0 {
            tableView.contentInset.top = -offset
        } else {
            tableView.contentInset.top = 0
        }
    }

}
