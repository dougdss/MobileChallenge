//
//  ReceiptsViewController.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 10/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

class ReceiptsViewController: UIViewController {

    var viewModel: ReceiptsViewModelType! {
        didSet {
            viewModel.viewDelegate = self
        }
    }
    
    var panGesture: UIPanGestureRecognizer!
    var initialTouchPoint: CGPoint = CGPoint.zero
    var receiptViewFrame: CGRect = CGRect.zero
    
    //view properties
    @IBOutlet weak var topIndicatorView: UIView!
    @IBOutlet weak var topIndicatorContainerView: UIView!
    @IBOutlet weak var receiptView: UIView!
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactUsernameLabel: UILabel!
    @IBOutlet weak var transactionDateLabel: UILabel!
    @IBOutlet weak var transacationIdLabel: UILabel!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardPaymentValueLabel: UILabel!
    @IBOutlet weak var totalPaymentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        topIndicatorContainerView.addGestureRecognizer(panGesture)
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        receiptViewFrame = receiptView.frame
    }
    
    func configureViews() {
        topIndicatorView.layer.cornerRadius = topIndicatorView.frame.height / 2
        contactImageView.layer.cornerRadius = contactImageView.bounds.width / 2
        contactImageView.layer.masksToBounds = true
        
        contactUsernameLabel.text = viewModel.contactUsername
        transactionDateLabel.text = viewModel.trasactionDate
        transacationIdLabel.text = viewModel.trasactionId
        cardNameLabel.text = viewModel.cardName
        cardPaymentValueLabel.text = viewModel.cardPaymentValue
        totalPaymentLabel.text = viewModel.totalPayment
        
        viewModel.contactImage { [weak self] (image) in
            self?.contactImageView.image = image
        }
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let touchPoint = gesture.location(in: self.view.window)
        
        switch gesture.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.receiptView.frame = CGRect(x: 0, y: (touchPoint.y - initialTouchPoint.y) + receiptViewFrame.origin.y, width: self.receiptView.frame.width, height: self.receiptView.frame.height)
            }
        case .cancelled, .ended:
            if touchPoint.y - initialTouchPoint.y > receiptView.frame.width / 2 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.receiptView.frame = self.receiptViewFrame
                }
            }
        default:
            break
        }
    }

}

extension ReceiptsViewController: ReceiptsViewModelViewDelegate {
    
}
