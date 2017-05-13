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
    
    @IBOutlet weak var buttonPoint: UIButton! {
        didSet {
            buttonPoint.setTitle(decimalSeparator, for: UIControlState())
        }
    }
    
    
    var userIsInTheMiddleOfTyping = false
    // var floatIsInTheMiddleOfTyping  = false  //MOVE IT TO touchDigit
    
    //MODEL {
    
    private var brain = CalculatorBrain()
    private var variables = [String:Double]()
    
    // }
    private let decimalSeparator = calcFormatter.decimalSeparator ?? "."
    
    
    
    var displayValue: Double {
        get {
            return calcFormatter.formatterStrToDbl(from: display.text!) ?? 0.0
        }
        set {
            display.text = calcFormatter.string(from: NSNumber(value: newValue))
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        
        // the decimal separator input processing
        if digit == decimalSeparator {
            
            guard !(display.text!.contains(decimalSeparator) && userIsInTheMiddleOfTyping) else {return}
            
            // for case if User start an input from the decimal separator
            if  !userIsInTheMiddleOfTyping  {
                display.text! = "0" + decimalSeparator
                userIsInTheMiddleOfTyping = true
                return
            }
            
            display.text! += digit
            userIsInTheMiddleOfTyping = true
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
    
    
    
    @IBAction func performOperation (_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathemaicalSymbol = sender.currentTitle {
            brain.performOperation(mathemaicalSymbol)
        }
        
        let (evaluateResult, resultIsPending, evaluateDesciption ) = brain.evaluate(using: variables)
        
        
        if let result = evaluateResult {
            displayValue = result
        }
        history.text = evaluateDesciption + (resultIsPending ? " _" : " =")
        
        
    }
    
    @IBAction func clearCalculator(_ sender: UIButton) {
        brain.clear()
        displayValue = 0
        history.text = " "
    }
    
    @IBAction func backspace(_ sender: UIButton) {
        
        guard userIsInTheMiddleOfTyping && !display.text!.isEmpty else {
            return
        }
        
        // delete the group separator together with gigit
        var textCurrentlyInDisplay = display.text!
        let index = textCurrentlyInDisplay.index(before: textCurrentlyInDisplay.endIndex)
        
        if String(textCurrentlyInDisplay[index]) == calcFormatter.groupingSeparator {
            display.text = String (display.text!.characters.dropLast())
        }
        
        // do backspace by dropLast method
        textCurrentlyInDisplay = display.text!
        textCurrentlyInDisplay = String (textCurrentlyInDisplay.characters.dropLast())
        let doubleCurrentTotal = calcFormatter.formatterStrToDbl(from: textCurrentlyInDisplay)  ?? 0.0
        display!.text  = calcFormatter.string(from: NSNumber(value: doubleCurrentTotal))
        
        if display.text!.isEmpty {
            displayValue = 0
            userIsInTheMiddleOfTyping = false
        }
    }
    
}




