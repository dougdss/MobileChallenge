//
//  PaymentViewController.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 09/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

class PaymentViewController: CustomNavBarViewController {

    var viewModel: PaymentViewModelType! {
        didSet {
            viewModel.viewDelegate = self
        }
    }

    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactUsernameLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var paymentValueLabel: UILabel!
    @IBOutlet weak var paymentButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let hiddenTextField: UITextField! = {
        let field = UITextField()
        field.spellCheckingType = .no
        field.keyboardType = .numberPad
        field.autocorrectionType = .no
        field.smartDashesType = .no
        field.smartQuotesType = .no
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(hiddenTextField)
        hiddenTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenTextField.becomeFirstResponder()
        hiddenTextField.addTarget(self, action: #selector(formatPaymentValue(_:)), for: .editingChanged)
        formatPaymentValue(hiddenTextField)
        configViews()
    }
    
    func configViews() {
        contactImageView.layer.cornerRadius = contactImageView.frame.width / 2
        contactImageView.layer.masksToBounds = true
        contactUsernameLabel.text = viewModel.paymentDestinationUsername
        cardNumberLabel.text = viewModel.paymentCardName
        viewModel.getUserImage { [weak self] (image) in
            DispatchQueue.main.async {
                self?.contactImageView.image = image
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hiddenTextField.removeTarget(self, action: #selector(formatPaymentValue(_:)), for: .editingChanged)
    }
    
    @objc func formatPaymentValue(_ sender: Any) {
        guard let paymentText = hiddenTextField.text else { return }
        viewModel.formatPaymentValue(textValue: paymentText)
    }
    
    func setAttributedText(withText text: String) {
        let attributedText = NSMutableAttributedString(string: "R$ \(text)")
        attributedText.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)], range: NSRange(location: 0, length: 2))
        attributedText.addAttributes([NSAttributedString.Key.baselineOffset : 12], range: NSRange(location: 0, length: 2))
        paymentValueLabel.attributedText = attributedText
    }
    
    func setIsValid(isValid: Bool) {
        paymentButton.isEnabled = isValid
        paymentButton.alpha = isValid ? 1.0 : 0.5
        paymentValueLabel.textColor = isValid ? .picpayDefaultGreenActionColor : .picpayTextFieldPlaceHolderColor
    }
    
    @IBAction func didTapPay(_ sender: Any) {
        viewModel.pay(fromController: self)
    }
    
    @IBAction func editCardButtonTapped(_ sender: Any) {
        
    }
}

extension PaymentViewController: PaymentViewModelViewDelegate {
    
    func validateForm(isValid: Bool) {
        setIsValid(isValid: isValid)
    }
    
    func updateState(state: ViewState) {
        switch state {
        case .loading:
            indicator.startAnimating()
            paymentButton.isHidden = true
        case .loaded:
            indicator.stopAnimating()
            paymentButton.isHidden = false
        }
    }
    
    func updatePaymentValueWith(formattedText text: String, andRawText: String) {
        hiddenTextField.text = andRawText
        setAttributedText(withText: text)
    }
    
    func showError(error: Error?) {
        let alert = UIAlertController(title: "Pagamento", message: "Não foi possível efetuar esse pagamento, verifique e tente novamente", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension PaymentViewController: UITextFieldDelegate {
 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 9
    }
    
}

