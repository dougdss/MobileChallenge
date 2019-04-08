//
//  RegisterCardFormViewController.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 07/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegisterCardFormViewController: CustomNavBarViewController {

    var viewModel: RegisterCardFormViewModelType! {
        didSet {
            viewModel.viewDelegate = self
        }    
    }
    
    var currentSelectedTextField: SkyFloatingLabelTextField?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cardNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var cardHolderNameLabel: SkyFloatingLabelTextField!
    @IBOutlet weak var cardDueDateLabel: SkyFloatingLabelTextField!

    //control for saveButton
    @IBOutlet weak var saveButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveButtonTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureTextFields() {
        cardNumberTextField.titleFormatter = { _ in return "Número do cartão" }
        cardHolderNameLabel.titleFormatter = { _ in return "Nome do titular" }
        cardDueDateLabel.titleFormatter = { _ in return "Vencimento" }
        cardNumberTextField.delegate = self
        cardHolderNameLabel.delegate = self
        cardDueDateLabel.delegate = self
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: Notification) {
//        print(notification.userInfo)
//        print("keyboard framebeginuserinfokey: \(notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey])")
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        guard let textField = currentSelectedTextField else {
            return
        }
        moveScrollViewOffset(forTextField: textField, keyboardFrame: frame)
        
    }
    
    @objc func handleKeyboardWillHide(notification: Notification) {
//        print(notification.userInfo)
//        print("keyboard framebeginuserinfokey: \(notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey])")
//        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
//            return
//        }
        scrollView.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
        saveButtonTopConstraint.priority = .defaultLow
        saveButtonBottomConstraint.priority = .defaultHigh
    }
    
    private func moveScrollViewOffset(forTextField textField: SkyFloatingLabelTextField, keyboardFrame kframe: CGRect) {
//        scrollView.setContentOffset(CGPoint(x: 0, y: kframe.origin.y), animated: true)
        let diff = textField.frame.origin.y - kframe.origin.y
        let absDiff = diff + navigationController!.navigationBar.frame.height + 20
        if absDiff > 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: abs(absDiff) + 80), animated: true)
            saveButtonTopConstraint.priority = .defaultHigh
            saveButtonBottomConstraint.priority = .defaultLow
        }
//        } else {
//            scrollView.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y), animated: true)
//        }
        
//        if textField.frame.origin.y > kframe.origin.y {
//            // move scrollOffset
////            scrollView.contentOffset = CGPoint(x: 0, y: textField.frame.origin.y)
//            scrollView.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y), animated: true)
//        }
    }
    
}

extension RegisterCardFormViewController: RegisterCardFormViewModelViewDelegate {
    
}

extension RegisterCardFormViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentSelectedTextField = (textField as? SkyFloatingLabelTextField)
        (textField as! SkyFloatingLabelTextField).setTitleVisible(true)
        (textField as! SkyFloatingLabelTextField).placeholderColor = .clear
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentSelectedTextField = nil
        (textField as! SkyFloatingLabelTextField).setTitleVisible(false)
        (textField as! SkyFloatingLabelTextField).placeholderColor = .picpayTextFieldPlaceHolderColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
