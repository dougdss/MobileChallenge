//
//  Formatters.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 11/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation


struct PaymentFormatter {
    
    static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.locale = Locale(identifier: "pt-BR")
        return formatter
    }
    
}

struct CardExpiryDateFormatter {
   
    static var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        formatter.locale = Locale(identifier: "pt-BR")
        return formatter
    }
    
}

struct TransactionDateFormatter {
    
    static var formatterForDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "pt-BR")
        return formatter
    }
    
    static var formatterForTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "pt-BR")
        return formatter
    }
    
}
