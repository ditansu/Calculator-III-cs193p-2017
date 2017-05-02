//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by di on 19.04.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import Foundation

func factorialCalc(digit : Double) -> Double {
    var n = Int(digit)
    var result = 1
    
    while n > 1 {
        result *= n
        n -= 1
    }
    return Double(result)
}

struct CalculatorBrain {
    
    private var accumulator: Double?
    private var descriptionAccumulator: String?
    private let calcFormatter  = CalculatorFormatter()
    
    var description: String? {
        get {
            if pendingBinaryOperation == nil {
                return descriptionAccumulator
            }else{
                return pendingBinaryOperation!.descriptionFunction(pendingBinaryOperation!.descriptionOperand, descriptionAccumulator ?? "")
            }
        }
    }
    
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    private enum Operation {
        case constant(Double)
        case nullaryOperation(()-> Double,String)
        case uanaryOperation ((Double)->Double,((String)->String)?)
        case binaryOperation ((Double,Double)->Double, ((String,String) -> String)?)
        case equals
        case clear
        case backspace
    }
    
    private var operations: Dictionary<String,Operation> =
        [
            "π"     :   Operation.constant(Double.pi),
            "cos"   :   Operation.uanaryOperation(cos,nil),
            "sin"   :   Operation.uanaryOperation(sin,nil),
            "e"     :   Operation.constant(M_E),
            "ln"    :   Operation.uanaryOperation({log($0)/log(M_E)},nil),
            "√"     :   Operation.uanaryOperation(sqrt,nil),
            "x²"    :   Operation.uanaryOperation({$0 * $0}, { "(" + $0 + ")²" }),
            "x!"    :   Operation.uanaryOperation(factorialCalc, { "(" + $0 + "!)" }),
            "x⁻¹"   :   Operation.uanaryOperation({1/$0}, { "(" + $0 + ")⁻¹" }),
            "±"     :   Operation.uanaryOperation({-$0},nil),
            "×"     :   Operation.binaryOperation(*,nil),
            "+"     :   Operation.binaryOperation(+,nil),
            "-"     :   Operation.binaryOperation(-,nil),
            "÷"     :   Operation.binaryOperation(/,nil),
            "Rand"  :   Operation.nullaryOperation({ Double(arc4random())/Double(UInt32.max) },"Rand()"),
            "="     :   Operation.equals,
            "С"     :   Operation.clear,
            "⌫"    :   Operation.backspace
        ]
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: ((Double,Double)->(Double))
        let firstOperand: Double
        var descriptionFunction: (String,String) -> String
        var descriptionOperand: String
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
        
        func performDescription (with secondOperand: String) -> String {
            return descriptionFunction(descriptionOperand, secondOperand)
        }

    }
    
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                descriptionAccumulator = symbol
            case .uanaryOperation (let function, var descFunction):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                    if descFunction == nil {
                        descFunction = {symbol + "(" + $0 + ")"}
                    }
                    descriptionAccumulator = descFunction!(descriptionAccumulator!)
                }
            case .binaryOperation(let function, var descFunction):
                
                if resultIsPending  {
                    performPendingBinaryOperation()
                }
                
                
                if accumulator != nil {
                    if descFunction == nil {
                        descFunction = {$0 + " " + symbol + " " + $1}
                    }
                    pendingBinaryOperation = PendingBinaryOperation(function: function,
                                                                    firstOperand: accumulator!,
                                                                    descriptionFunction: descFunction!,
                                                                    descriptionOperand: descriptionAccumulator!)
                    accumulator = nil
                    descriptionAccumulator = nil
                }
            case .nullaryOperation(let function, let descValue):
                accumulator = function()
                descriptionAccumulator = descValue
            case .clear:
                accumulator = nil
                descriptionAccumulator = " "
                pendingBinaryOperation = nil
            case .equals:
                performPendingBinaryOperation()
            case .backspace:
                break
                
            }
        }
    }
    
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            
            descriptionAccumulator = pendingBinaryOperation!.performDescription(with: descriptionAccumulator!)
            
            pendingBinaryOperation = nil
        }
    }
    
    mutating func setOperand(_ operand: Double){
        accumulator = operand
        if let value = accumulator {
            descriptionAccumulator = calcFormatter.string(from: NSNumber(value : value))
        }
        
    }
    
    var result : Double? {
        get {
            return accumulator
        }
    }
}
