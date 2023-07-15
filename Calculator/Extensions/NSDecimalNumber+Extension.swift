//
//  Calculator, NSDecimalNumberExtension.swift
//  macOS 13.3, Swift 5.0
//
//  Created by zo_glass
//
        

import Foundation

// MARK: - NSDecimalNumber

extension NSDecimalNumber {
    func valueOf(string value: String) -> NSDecimalNumber? {
        switch value {
        case "Error":
            return nil
        default:
            return NSDecimalNumber(string: value)
        }
    }
}

