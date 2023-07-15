//
//  Calculator, Formatter.swift
//  macOS 13.3, Swift 5.0
//
//  Created by zo_glass
//
        

import UIKit

// MARK: - Formatter

struct Number {
    
    // MARK: - Attributes
    
    var value: String
    
    // MARK: - init
    
    init(value: String) {
        self.value = value
    }
    
    // MARK: - Methods
    
    mutating func append(_ number: String) {
        if value
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: "-", with: "")
            .count >= 9
            { return }
        if value == "0" {
            value = number
        } else {
            value += number
        }
    }
    
    mutating func addDot() {
        if !value.contains(".") {
            value = value + "."
        }
    }
    
    func getFomattedString() -> String {
        guard let convertedNumber = Double(value) else { return "Error" }
        let numberFormatter = NumberFormatter()
        var formattedNumber: String
        let numberOfIntegerDigits = value
                                    .replacingOccurrences(of: "-", with: "")
                                    .split(separator: ".")[0]
                                    .count
        
        if numberOfIntegerDigits <= 9 && (convertedNumber == 0 || abs(convertedNumber) >= 0.00000001) {
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 9 - numberOfIntegerDigits
        } else {
            numberFormatter.numberStyle = .scientific
            numberFormatter.positiveFormat = "0.######E0"
            numberFormatter.exponentSymbol = "e"
        }
        
        formattedNumber = numberFormatter.string(from: NSNumber(value: convertedNumber)) ?? "Error"
        
        if value.hasSuffix(".") {
            formattedNumber += "."
        }
        
        return formattedNumber
    }
}

