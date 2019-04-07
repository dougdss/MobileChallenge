//
//  CreditCardService.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 07/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation
import CoreData

protocol CreditCardService {
    func saveCreditCard(creditCard: CreditCard, completion: @escaping (_ success: Bool) -> Void)
}

class CreditCardCoreDataService: CreditCardService {
    
    let dataManager: CoreDataManager
    
    init(dataManager: CoreDataManager) {
        self.dataManager = dataManager
    }
    
    func saveCreditCard(creditCard: CreditCard, completion: @escaping (Bool) -> Void) {
        let entity = NSEntityDescription.entity(forEntityName: "CreditCard", in: dataManager.managedObjectContext!)
        let card = NSManagedObject(entity: entity!, insertInto: dataManager.managedObjectContext!)
        card.setValue("cc", forKey: "number")
        do {
            try dataManager.managedObjectContext?.save()
        } catch {
            print("Something wrong")
        }
    }
    
}
