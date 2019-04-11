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
    @IBOutlet weak var cardHolderNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var cardDueDateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var cardCVVTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var saveButton: UIButton!
    
    //control for saveButton
    @IBOutlet weak var saveButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveButtonTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        configTapGesture()
        
        if viewModel.isUpdatingCard {
            updateCardInformation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        clearTargets()
        if isMovingFromParent {
            viewModel.didTouchBackButton()
        }
    }
    
    private func configTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(gesture: UITapGestureRecognizer) {
        currentSelectedTextField?.resignFirstResponder()
    }
    
    private func configureTextFields() {
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
        cardNumberTextField.titleFormatter = { _ in return "Número do cartão" }
        cardHolderNameTextField.titleFormatter = { _ in return "Nome do titular" }
        cardDueDateTextField.titleFormatter = { _ in return "Vencimento" }
        cardCVVTextField.titleFormatter = { _ in return "CVV" }
        cardNumberTextField.delegate = self
        cardHolderNameTextField.delegate = self
        cardDueDateTextField.delegate = self
        cardCVVTextField.delegate = self
        
        cardNumberTextField.addTarget(self, action: #selector(formatCardNumber(_:)), for: .editingChanged)
        cardDueDateTextField.addTarget(self, action: #selector(formatCardExpiryDate(_:)), for: .editingChanged)
        cardCVVTextField.addTarget(self, action: #selector(cardCvvEditingChanged(_:)), for: .editingChanged)
        cardHolderNameTextField.addTarget(self, action: #selector(cardHolderNameEditingChanged(_:)), for: .editingChanged)
    }
    
    private func clearTargets() {
        cardNumberTextField.removeTarget(self, action: #selector(formatCardNumber(_:)), for: .editingChanged)
        cardDueDateTextField.removeTarget(self, action: #selector(formatCardExpiryDate(_:)), for: .editingChanged)
        cardCVVTextField.removeTarget(self, action: #selector(cardCvvEditingChanged(_:)), for: .editingChanged)
        cardHolderNameTextField.removeTarget(self, action: #selector(cardHolderNameEditingChanged(_:)), for: .editingChanged)
    }
    
    @objc func formatCardNumber(_ sender: Any) {
        viewModel.formatCardNumber(cardNumber: cardNumberTextField.text ?? "")
    }
    
    @objc func formatCardExpiryDate(_ sender: Any) {
        viewModel.formatCardExpiryDate(cardExpiryDate: cardDueDateTextField.text ?? "")
    }
    
    @objc func cardCvvEditingChanged(_ sender: Any) {
        viewModel.formatCardCvv(cardCVV: cardCVVTextField.text ?? "")
    }
    
    @objc func cardHolderNameEditingChanged(_ sender: Any) {
        viewModel.formatCardHolderName(cardHolderName: cardHolderNameTextField.text ?? "")
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: Notification) {
        guard let endframe = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        guard let textField = currentSelectedTextField else {
            return
        }
        moveScrollViewOffset(forTextField: textField, keyboardFrame: endframe)
        
    }
    
    @objc func handleKeyboardWillHide(notification: Notification) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        saveButtonTopConstraint.priority = .defaultLow
        saveButtonBottomConstraint.priority = .defaultHigh
    }
    
    private func moveScrollViewOffset(forTextField textField: SkyFloatingLabelTextField, keyboardFrame kframe: CGRect) {
        if textField.frame.maxY < kframe.origin.y - 64 {
            return
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: textField.frame.maxY - kframe.height), animated: true)
            saveButtonTopConstraint.priority = .defaultHigh
            saveButtonTopConstraint.constant = 20
            saveButtonBottomConstraint.priority = .defaultLow
        }
    }
    
    @IBAction func didTapSaveCard(_ sender: Any) {
        let card = CreditCard.init(cardNumber: viewModel.cardNumber, cardHolderName: viewModel.holderName, dueDate: viewModel.dueDate, cardCVV: viewModel.cvv)
        if viewModel.isUpdatingCard {
            viewModel.updateCard(card: card, from: self)
        } else {
            viewModel.saveCard(card: card, from: self)
        }
        
    }

}

extension RegisterCardFormViewController: RegisterCardFormViewModelViewDelegate {
    
    func showSaveCardSuccess(completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Salvar Cartão", message: "Sucesso", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            completion()
        })
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showError(error: Error?) {
        print(error?.localizedDescription ?? "")
        let alert = UIAlertController(title: "Salvar Cartão", message: "Não foi possível salvar seu cartão, verifique e tente novamente", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func updateCardInformation() {
        cardNumberTextField.text = viewModel.cardNumber
        cardDueDateTextField.text = CardExpiryDateFormatter.formatter.string(from: viewModel.dueDate)
        cardCVVTextField.text = viewModel.cvv
        cardHolderNameTextField.text = viewModel.holderName
        cardHolderNameEditingChanged(cardHolderNameTextField)
    }
    
    func updateCardNumber(cardNumber: String) {
        cardNumberTextField.text = cardNumber
    }
    
    func updateCardExpiryDate(expiryDate: String) {
        cardDueDateTextField.text = expiryDate
    }
    
    func isFormValid(valid: Bool) {
        saveButton.isHidden = !valid
    }
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        let skyFloatingLabelTextField = (textField as! SkyFloatingLabelTextField)
        if skyFloatingLabelTextField.isEqual(cardNumberTextField) {
            return count <= 19
        } else if skyFloatingLabelTextField.isEqual(cardDueDateTextField) {
            return count <= 5
        } else if skyFloatingLabelTextField.isEqual(cardCVVTextField) {
            return count <= 3
        } else {
            return count <= 40 // for holder name
        }
    }

}
