//
//  Coordinator.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 03/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation

class Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    func start() {
        fatalError("should be implemented by subclasses")
    }
    
    func finish() {
        fatalError("should be implemented by subclasses")
    }
    
    func addChildCoordinator(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (coord) -> Bool in
            return coord == coordinator
        }) {
            childCoordinators.remove(at: index)
        } else {
            print("The coordinator passed for the function is not a child coordinator")
        }
    }
    
    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
}

extension Coordinator: Equatable {
    
    static func ==(lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
    
}
