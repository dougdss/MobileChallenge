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
    
    //view properties
    @IBOutlet weak var topIndicatorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        view.addGestureRecognizer(panGesture)
        configureViews()
    }
    
    func configureViews() {
        topIndicatorView.layer.cornerRadius = topIndicatorView.frame.height / 2
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let touchPoint = gesture.location(in: self.view.window)
        
        switch gesture.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.width, height: self.view.frame.height)
            }
        case .cancelled, .ended:
            if touchPoint.y - initialTouchPoint.y > view.frame.width / 2 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                }
            }
        default:
            break
        }
    }
}

extension ReceiptsViewController: ReceiptsViewModelViewDelegate {
    
}
