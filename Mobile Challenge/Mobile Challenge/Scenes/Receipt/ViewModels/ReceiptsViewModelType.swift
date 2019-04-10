//
//  ReceiptsViewModelType.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 10/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

protocol ReceiptsViewModelType {
    
    var viewDelegate: ReceiptsViewModelViewDelegate? { get set }
    
}

protocol ReceiptsViewModelCoordinatorDelegate:class {
    func didCloseReceipt()
}

protocol ReceiptsViewModelViewDelegate:class {
    
}
