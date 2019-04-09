//
//  CreditCardFormatter.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 09/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation

class CreditCardFormatter {
    
    class func formatCreditCard(withText text: String) -> String {
        let newText = text.trimmingCharacters(in: .punctuationCharacters)
            .trimmingCharacters(in: .letters)
            .trimmingCharacters(in: .lowercaseLetters)
            .trimmingCharacters(in: .whitespaces)
            .trimmingCharacters(in: CharacterSet.init(charactersIn: " ")).replacingOccurrences(of: " ", with: "")
        
        var output = ""
        
        switch newText.count {
        case 1,2,3,4:
            output = "\(newText[..<newText.endIndex])"
        case 5,6,7,8:
            output = "\(newText[..<newText.index(newText.startIndex, offsetBy: 4)])"
                + " "
                + "\(newText[newText.index(newText.startIndex, offsetBy: 4)...])"
        case 9,10,11,12:
            output = "\(newText[..<newText.index(newText.startIndex, offsetBy: 4)])"
                + " "
                + "\(newText[newText.index(newText.startIndex, offsetBy: 4)..<newText.index(newText.startIndex, offsetBy: 8)])"
                + " "
                + "\(newText[newText.index(newText.startIndex, offsetBy: 8)...])"
        case 13,14,15,16:
            output = "\(newText[..<newText.index(newText.startIndex, offsetBy: 4)])"
                + " "
                + "\(newText[newText.index(newText.startIndex, offsetBy: 4)..<newText.index(newText.startIndex, offsetBy: 8)])"
                + " "
                + "\(newText[newText.index(newText.startIndex, offsetBy: 8)..<newText.index(newText.startIndex, offsetBy: 12)])"
                + " "
                + "\(newText[newText.index(newText.startIndex, offsetBy: 12)...])"
        default:
            output = ""
        }
        
        return output
    }
    
    
    static func formatCreditCardExpiryDate(withText text: String) -> String {
        let newText = text.trimmingCharacters(in: .punctuationCharacters)
            .trimmingCharacters(in: .letters)
            .trimmingCharacters(in: .lowercaseLetters)
            .trimmingCharacters(in: .whitespaces)
            .trimmingCharacters(in: CharacterSet.init(charactersIn: " "))
            .replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "/", with: "")
        
        var output = ""
        
        switch newText.count {
        case 1,2:
            output = "\(newText[..<newText.endIndex])"
        case 3,4:
            output = "\(newText[..<newText.index(newText.startIndex, offsetBy: 2)])"
                + "/"
                + "\(newText[newText.index(newText.startIndex, offsetBy: 2)...])"
        default:
            output = ""
        }
        
        return output
    }
}
