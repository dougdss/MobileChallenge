//
//  Result.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 04/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
