//
//  ReceiptsCoordinator.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 10/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

protocol ReceiptsCoordinatorDelegate:class {
    func didFinish(fromCoordinator coordinator: ReceiptsCoordinator)
}

class ReceiptsCoordinator: Coordinator {
    
    var rootViewController: UIViewController
    weak var delegate: ReceiptsCoordinatorDelegate?
    
    var viewModel: ReceiptsViewModelType {
        let vModel = ReceiptsViewModel()
        vModel.coordinatorDelegate = self
        return vModel
    }
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() {
        let receiptVC = ReceiptsViewController()
        receiptVC.modalPresentationStyle = .overFullScreen
        rootViewController.navigationController?.present(receiptVC, animated: true, completion: nil)
    }
    
    override func finish() {
        delegate?.didFinish(fromCoordinator: self)
    }
    
}

extension ReceiptsCoordinator: ReceiptsViewModelCoordinatorDelegate {
    
    func didCloseReceipt() {
        finish()
    }
}
