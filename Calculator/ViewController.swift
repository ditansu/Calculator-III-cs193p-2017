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
    @IBOutlet weak var displayM: UILabel!
    
    @IBOutlet weak var buttonPoint: UIButton! {
        didSet {
            buttonPoint.setTitle(decimalSeparator, for: UIControlState())
        }
    }
    
    
    var userIsInTheMiddleOfTyping = false
    
    //MODEL {
    
    private var brain = CalculatorBrain()
    private var variables = [String:Double]()
    
    // }
    
    private let decimalSeparator = calcFormatter.decimalSeparator ?? "."
    
    var displayResult : (result : Double?, isPending : Bool, Description: String, error : String?) = (nil, false, " ",nil) {
        didSet {
            switch displayResult {
            case (nil, _, " ",nil) : displayValue = 0
            case (let result, _, _,nil) : displayValue = result
            case ( _, _, _, let error) : display.text = error!
            }
            
            history.text = displayResult.Description != " " ? displayResult.Description + (displayResult.isPending ? " _" : " =") : " "
            displayM.text = calcFormatter.string(from: NSNumber(value: variables["M"] ?? 0))
        }
    }
    
    var displayValue: Double? {
        get {
            return calcFormatter.formatterStrToDbl(from: display.text!) ?? 0.0
        }
        set {
            if let value = newValue {
                display.text = calcFormatter.string(from: NSNumber(value: value))
            }
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
            if let value = displayValue {
                brain.setOperand(value)
            }
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathemaicalSymbol = sender.currentTitle {
            brain.performOperation(mathemaicalSymbol)
        }
        
        displayResult = brain.evaluate(using: variables)
    }
    
    @IBAction func clearCalculator(_ sender: UIButton) {
        brain.clear()
        variables = [:]
        displayResult = brain.evaluate()
    }
    
    @IBAction func backspace(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            guard  !display.text!.isEmpty else { return }
            
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
                userIsInTheMiddleOfTyping = false
                displayResult = brain.evaluate(using: variables)
                
            }
        } else {
            brain.undo()
            displayResult = brain.evaluate(using: variables)
        }
    }
    
    @IBAction func setM(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        
        let symbol = String((sender.currentTitle!).characters.dropFirst())
        variables[symbol] = displayValue
        
        displayResult = brain.evaluate(using: variables)
        
    }
    
    @IBAction func pushM(_ sender: UIButton) {
        
        brain.setOperand(variable: sender.currentTitle!)
        displayResult = brain.evaluate(using: variables)
        
    }
    
}




