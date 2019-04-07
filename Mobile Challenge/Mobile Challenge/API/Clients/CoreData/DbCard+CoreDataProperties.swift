//
//  DbCard+CoreDataProperties.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 07/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//
//

import Foundation
import CoreData

extension DbCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DbCard> {
        return NSFetchRequest<DbCard>(entityName: "DbCard")
    }

    @NSManaged public var cardNumber: String?
    @NSManaged public var holderName: String?
    @NSManaged public var dueDate: NSDate?
    @NSManaged public var cvv: Int16

}
