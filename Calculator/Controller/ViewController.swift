//
//  Calculator, ViewController.swift
//  macOS 13.3, Swift 5.0
//
//  Created by zo_glass
//
        

import UIKit

// MARK: - UIViewController

class ViewController: UIViewController {
    
    // MARK: - Attributes
    
    var operand1: Number = .init(value: "0") {
        didSet {
            displayLabel.text = operand1.getFomattedString()
        }
    }
    var operand2: Number? {
        didSet {
            if let operand2, operation != nil {
                displayLabel.text = operand2.getFomattedString()
            }
        }
    }
    var operation: Operator.Operation?
    var isValue1Operated: Bool = false
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet var operationButtonCollection: [UIButton]!
    @IBOutlet var allButtonCollection: [UIButton]!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        clear()
    }
    
    // MARK: - IBActions
    
    @IBAction func clearTapped(_ sender: Any) {
        clear()
    }
    
    @IBAction func numericTapped(_ sender: UIButton) {
        let number = String(sender.tag)
        
        workWith(firstOperand: {
            operand1.append(number)
        }, secondOperand: {
            if operand2 != nil {
                operand2?.append(number)
            } else {
                operand2 = .init(value: number)
            }
        })
        
        if number != "0" {
            setClearButtonText(to: "C")
        }
        clearOperationButtons()
    }
    
    @IBAction func dotTapped(_ sender: UIButton) {
        workWith(firstOperand: {
            operand1.addDot()
        }, secondOperand: {
            if operand2 != nil {
                operand2?.addDot()
            } else {
                operand2 = .init(value: "0.")
            }
        })
        
        setClearButtonText(to: "C")
        clearOperationButtons()
    }
    
    @IBAction func operationTapped(_ sender: UIButton) {
        let tag = sender.tag
        
        operation = Operator.Operation(rawValue: tag)
        if isValue1Operated {
            operand2 = nil
            isValue1Operated = false
        }
        
        clearOperationButtons()
        sender.backgroundColor = .white
        sender.tintColor = .orange
    }
    
    @IBAction func equalsTapped(_ sender: UIButton) {
        guard let operation else { return }
        operand2 = operand2 ?? operand1
        
        do{
            operand1.value = try Operator().operate(operand1, operation: operation, operand2!)
        } catch {
            operand1.value = "Error"
        }
        
        isValue1Operated = true
        clearOperationButtons()
    }
    
    @IBAction func plusMinusTapped(_ sender: UIButton) {
        workWith(firstOperand: {
            do {
                try Operator().invert(&operand1.value)
            } catch {
                operand1.value = "Error"
            }
        }, secondOperand: {
            do {
                operand2 = operand2 ?? Number(value: "0")
                try Operator().invert(&operand2!.value)
            } catch {
                operand2?.value = "Error"
            }
        })
    }
    
    @IBAction func percentageTapped(_ sender: UIButton) {
        workWith(firstOperand: {
            do {
                operand1.value = try Operator().percentage(of: operand1)
            } catch {
                operand1.value = "Error"
            }
        }, secondOperand: {
            operand2 = operand2 ?? operand1
            do {
                let n2 = try Operator().percentage(of: operand2!)
                operand2?.value = try Operator().operate(operand1, operation: .multiplication, Number(value: n2))
            } catch {
                operand2?.value = "Error"
            }
        })
    }
    
    // MARK: - Methods
    
    func workWith(firstOperand: () -> Void, secondOperand: () -> Void) {
        if operation == nil || isValue1Operated {
            firstOperand()
        } else {
            secondOperand()
        }
    }
    
    func clear() {
        operand1.value = "0"
        operand2 = nil
        operation = nil
        isValue1Operated = false
        clearOperationButtons()
        setClearButtonText(to: "AC")
    }
    
    func clearOperationButtons() {
        for operationButton in operationButtonCollection {
            operationButton.backgroundColor = .orange
            operationButton.titleLabel?.textColor = .white
        }
    }
    
    func setClearButtonText(to value: String) {
        let fontAttribute = [ NSAttributedString.Key.font: UIFont(name: "Velour", size: 28.0)! ]
        clearButton.setAttributedTitle(NSAttributedString(string: value, attributes: fontAttribute), for: .normal)
    }
    
    func configureView() {
        displayLabel.adjustsFontSizeToFitWidth = true
        displayLabel.minimumScaleFactor = 0.2
        for button in allButtonCollection {
            button.layer.cornerRadius = 0.5 * button.bounds.size.height
            button.clipsToBounds = true
        }
        clearOperationButtons()
    }
}

