//
//  Calculator, Operator.swift
//  macOS 13.3, Swift 5.0
//
//  Created by zo_glass
//
        

import UIKit

// MARK: - Enums

extension Operator {
    
    enum Operation: Int {
        case addition
        case subtraction
        case multiplication
        case division
    }

    enum OperationError: Error {
        case nan
        case divideByZero
    }
}

// MARK: - Operator

class Operator {
    
    // MARK: - Attributes
    
    private let decimalNumber = NSDecimalNumber()
    
    // MARK: - Methods
    
    func operate(_ operand1: Number, operation: Operation, _ operand2: Number) throws -> String {
        guard let v1 = decimalNumber.valueOf(string: operand1.value),
              let v2 = decimalNumber.valueOf(string: operand2.value) else { throw OperationError.nan }
        
        let result: NSDecimalNumber
        switch operation {
        case .addition:
            result = v1.adding(v2, withBehavior: self)
        case .subtraction:
            result = v1.subtracting(v2, withBehavior: self)
        case .multiplication:
            result = v1.multiplying(by: v2, withBehavior: self)
        case .division:
            if v2 == 0 { throw OperationError.divideByZero }
            result = v1.dividing(by: v2, withBehavior: self)
        }
        
        if result.doubleValue.isNaN { throw OperationError.nan }
        return String(describing: result)
    }
    
    func percentage(of operand: Number) throws -> String {
        guard let number = decimalNumber.valueOf(string: operand.value) else { throw OperationError.nan }
        
        let result: NSDecimalNumber
        result = number.dividing(by: 100.0, withBehavior: self)
        
        if result.doubleValue.isNaN { throw OperationError.nan }
        return String(describing: result)
    }
    
    func invert(_ value: inout String) throws {
        guard Double(value) != nil else { throw OperationError.nan }
        
        if value.prefix(1) == "-" {
            value.remove(at: value.startIndex)
        } else {
            value.insert("-", at: value.startIndex)
        }
    }
    
}

// MARK: - NSDecimalNumberBehaviors

extension Operator: NSDecimalNumberBehaviors {
    func roundingMode() -> NSDecimalNumber.RoundingMode {
        return .plain
    }
    
    func scale() -> Int16 {
        return Int16(NSDecimalNoScale)
    }
    
    func exceptionDuringOperation(_ operation: Selector, error: NSDecimalNumber.CalculationError, leftOperand: NSDecimalNumber, rightOperand: NSDecimalNumber?) -> NSDecimalNumber? {
        return nil
    }
}

