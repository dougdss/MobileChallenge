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
    func saveCreditCard(creditCard: CreditCard, completion: @escaping (_ success: Bool, _ error: Error?) -> Void)
    func loadSavedCard(completion: (_ creditCard: CreditCard?, _ error: Error?) -> Void)
}

class CreditCardCoreDataService: CreditCardService {
    
    let dataManager: CoreDataManager
    
    init(dataManager: CoreDataManager) {
        self.dataManager = dataManager
    }
    
    func saveCreditCard(creditCard: CreditCard, completion: @escaping (Bool, Error?) -> Void) {
        
        guard let context = dataManager.managedObjectContext else {
            completion(false, NSError(domain: "mobilechallenge.coredata.error", code: 99, userInfo: [NSLocalizedDescriptionKey: "coredata managedContext is nil"]))
            return
        }
        
        let dbCard = DbCard(context: context)
        dbCard.cardNumber = creditCard.cardNumber
        dbCard.holderName = creditCard.cardHolderName
        dbCard.dueDate = creditCard.dueDate
        dbCard.cvv = creditCard.cardCVV
        
        do {
            try context.save()
            completion(true, nil)
        } catch let err {
            completion(false, err)
        }
    }
 
    func loadSavedCard(completion: (CreditCard?, Error?) -> Void) {
        do {
            let error = NSError(domain: "mobilechallenge.coredata", code: 98, userInfo: [NSLocalizedDescriptionKey: "could not load saved card or no card has been saved yet."])
            
            let result = try dataManager.managedObjectContext?.fetch(DbCard.fetchRequest())
            guard  result != nil, let cards = result as? [DbCard] else {
                completion(nil, error)
                return
            }
            
            if let dbCard = cards.first {
                let card = CreditCard.init(cardNumber: dbCard.cardNumber ?? "",
                                           cardHolderName: dbCard.holderName ?? "",
                                           dueDate: dbCard.dueDate ?? Date(),
                                           cardCVV: dbCard.cvv ?? "")
                completion(card, nil)
                return
            }
            
            completion(nil, error)
            
        } catch let err {
            completion(nil, err)
        }
    }
    
}
