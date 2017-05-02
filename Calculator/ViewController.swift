//
//  ViewController.swift
//  Calculator
//
//  Created by di on 18.04.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    var floatIsInTheMiddleOfTyping  = false
    
    let calcFormatter = CalculatorFormatter()
    
    
    @IBAction func touchDigit(_ sender: UIButton) {
        var digit = sender.currentTitle!
        
        // blocking second separater input
        if digit == "." {
            
            if floatIsInTheMiddleOfTyping {
                return
            } else {
                floatIsInTheMiddleOfTyping = true
            }
            
            digit = calcFormatter.decimalSeparator
            display.text! += digit
            userIsInTheMiddleOfTyping = true
            return
        }
        
        if floatIsInTheMiddleOfTyping {
            display.text! += digit
            return
        }
        
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            let bufferForDisplayedText  = textCurrentlyInDisplay + digit
            let doubleCurrentTotal = calcFormatter.formatterStrToDbl(from:  bufferForDisplayedText)  ?? 0.0
            display!.text  = calcFormatter.string(from: NSNumber(value: doubleCurrentTotal))
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    
    
    var displayValue: Double {
        get {
            return calcFormatter.formatterStrToDbl(from: display.text!) ?? 0.0
        }
        set {
            display.text = calcFormatter.string(from: NSNumber(value: newValue))
        }
    }
    
  
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation (_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
            floatIsInTheMiddleOfTyping  = false
        }
        
        if let mathemaicalSymbol = sender.currentTitle {
            brain.performOperation(mathemaicalSymbol)
        }
        
        if let result = brain.result {
            displayValue = result
        }
        history.text = brain.description! + (brain.resultIsPending ? " _" : " =")
    }
    
    @IBAction func clearCalculator(_ sender: UIButton) {
        brain.performOperation("C")
        displayValue = 0
        history.text = " "
    }
    
    @IBAction func backspace(_ sender: UIButton) {
        
        guard userIsInTheMiddleOfTyping && !display.text!.isEmpty else {
            return
        }
        
        // delete the group separator together with gigit
        let textCurrentlyInDisplay = display.text!
        let index = textCurrentlyInDisplay.index(before: textCurrentlyInDisplay.endIndex)
       
        if String(textCurrentlyInDisplay[index]) == calcFormatter.groupingSeparator {
            display.text = String (display.text!.characters.dropLast())
        }
        
        // do backspace by dropLast method
        display.text = String (display.text!.characters.dropLast())
        if display.text!.isEmpty {
            displayValue = 0
            userIsInTheMiddleOfTyping = false
            floatIsInTheMiddleOfTyping  = false
        }
    }
    
}




