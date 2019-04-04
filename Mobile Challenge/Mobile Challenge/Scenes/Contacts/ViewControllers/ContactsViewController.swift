//
//  ContactsViewController.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 03/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

class ContactsViewController: BaseNavigationControllerChild {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var searchBar: ContactsSearchBar?
    
    var viewModel: ContactsViewModelType! {
        didSet {
            viewModel.viewDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.loadContacts()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        tableView.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(gesture: UITapGestureRecognizer) {
        searchBar?.resignFirstResponder()
    }
    
    private func setupViews() {
        self.title = "Contatos"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ContactsSearchBarTableHeaderView.identifier, bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: ContactsSearchBarTableHeaderView.identifier)
        configBackgroundView()
    }
    
    private func configBackgroundView() {
        let errorView = ContactsErrorView()
        errorView.delegate = self
        tableView.backgroundView = errorView
    }

}

extension ContactsViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        (searchBar as! ContactsSearchBar).isActive = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numbersOfitems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewdata = viewModel.itemFor(row: indexPath.row)
        let cell = UITableViewCell()
        cell.backgroundColor = .picpayDefaultBlackBackground
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = viewdata.name
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
        
        // Very simple way of show/hide navigationBar - need improvement
        let offset = scrollView.contentOffset.y
        if offset > 20 {
            if !self.navigationController!.isNavigationBarHidden {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                return
            }
        } else {
            if self.navigationController!.isNavigationBarHidden {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                return
            }
        }
    }
}
