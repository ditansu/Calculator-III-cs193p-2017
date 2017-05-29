//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by di on 19.04.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    
    // Private members


    // new elements for resolve task #2
    private enum OpStack {
        case operand (Double)
        case operation (String)
        case variable (String)
    }
    
    private var internalProgram = [OpStack] ()
    
    
    
    // Public Methods
    
    
    mutating func setOperand(variable named: String){
        internalProgram.append(OpStack.variable(named))
    }
    
    mutating func setOperand(_ operand: Double){
        internalProgram.append(OpStack.operand(operand))
    }
    
    mutating func performOperation(_ symbol: String) {
        internalProgram.append(OpStack.operation(symbol))
    }
    
    mutating func clear(){
        internalProgram.removeAll()
    }
    
    mutating func undo(){
        if !internalProgram.isEmpty {
            internalProgram = Array(internalProgram.dropLast())
        }
    }
    
    
    
    //
    // HI-ORDER FUNCTION
    //
    
    func evaluate(using variables: Dictionary <String,Double>? = nil) -> (result : Double?,isPending : Bool, Description: String, error: String?) {
        
        //
        // Var & const section
        //
        
         enum Operation {
            case constant(Double)
            case nullaryOperation(()-> Double,String)
            case uanaryOperation ((Double)->Double,((String)->String)?,((Double)->String?)?)
            case binaryOperation ((Double,Double)->Double, ((String,String) -> String)?,((Double,Double) -> String?)?, Int)
            case equals
        }
        
         var operations: Dictionary<String,Operation> = [
            "π"         :   Operation.constant(Double.pi),
            "cos"       :   Operation.uanaryOperation(cos,nil,nil),
            "sin"       :   Operation.uanaryOperation(sin,nil,nil),
            "cos⁻¹"     :   Operation.uanaryOperation(acos,nil,{ $0 < -1.0 || $0 > 1.0 ? "не в диапозоне [-1,1]" : nil}),
            "sin⁻¹"     :   Operation.uanaryOperation(asin,nil,{ $0 < -1.0 || $0 > 1.0 ? "не в диапозоне [-1,1]" : nil}),
            "tan"       :   Operation.uanaryOperation(tan,nil,nil),
            "tan⁻¹"     :   Operation.uanaryOperation(atan,nil,nil),
            "e"         :   Operation.constant(M_E),
            "ln"        :   Operation.uanaryOperation(log,nil, {$0 <= 0.0 ? "ln <= 0.0" : nil}),
            "log"       :   Operation.uanaryOperation(log10,nil,nil),
            "√"         :   Operation.uanaryOperation(sqrt,nil, {$0 < 0 ? "√ отриц. числа" : nil}),
            "x²"        :   Operation.uanaryOperation({$0 * $0}, { "(" + $0 + ")²" },nil),
            "xʸ"        :   Operation.binaryOperation(pow, {$0 + " ^ " + $1},nil,2),
            "x!"        :   Operation.uanaryOperation(factorialCalc, { "(" + $0 + "!)" }, {$0 > 20.0 ? "переполнение" : nil }),
            "x⁻¹"       :   Operation.uanaryOperation({1/$0}, { "(" + $0 + ")⁻¹" }, {$0 == 0.0 ? "деление на ноль" : nil}),
            "±"         :   Operation.uanaryOperation({-$0},nil,nil),
            "×"         :   Operation.binaryOperation(*,nil,nil,1),
            "+"         :   Operation.binaryOperation(+,nil,nil,0),
            "-"         :   Operation.binaryOperation(-,nil,nil,0),
            "÷"         :   Operation.binaryOperation(/,nil,{$1 == 0.0 ? "деление на ноль" : nil},1),
            "Rand"      :   Operation.nullaryOperation({ Double(arc4random())/Double(UInt32.max) },"Rand()"),
            "="         :   Operation.equals
        ]
        
        
         struct PendingBinaryOperation {
            let function: ((Double,Double)->(Double))
            let firstOperand: Double
            var descriptionFunction: (String,String) -> String
            var descriptionOperand: String
            var validator : ((Double,Double) -> String?)?
            var priority : Int
            var prevPriority : Int
            
            func perform(with secondOperand: Double) -> Double {
                return function(firstOperand, secondOperand)
            }
            
            func performDescription (with secondOperand: String) -> String {
                var descriptionOperandNew = descriptionOperand
                if prevPriority < priority {
                    descriptionOperandNew = "(" + descriptionOperandNew + ")"
                }
                return descriptionFunction(descriptionOperandNew, secondOperand)
            }
            
            func validate(with secondOperand: Double) -> String? {
                guard let validator = validator else {return nil}
                return validator(firstOperand,secondOperand)
            }
            
        }

        
        
        var cache: (accumulator : Double?, descriptionAccumulator : String?)
        var error : String?
        var pendingBinaryOperation: PendingBinaryOperation?
        var prevPriority = Int.max
        
        var description: String? {
            get {
                if pendingBinaryOperation == nil {
                    return cache.descriptionAccumulator
                }else{
                    return pendingBinaryOperation!.descriptionFunction(pendingBinaryOperation!.descriptionOperand, cache.descriptionAccumulator ?? "")
                }
            }
        }
        
        var result : Double? {
            get {
                return cache.accumulator
            }
        }
        
        var resultIsPending: Bool {
            get {
                return pendingBinaryOperation != nil
            }
        }
        
        //
        // Nested func for calc
        //
        
        func setOperand(_ operand: Double){
            cache.accumulator = operand
            if let value = cache.accumulator {
                cache.descriptionAccumulator = calcFormatter.string(from: NSNumber(value : value))
            }
        }
        
        func setOperand(variable named: String){
            cache.accumulator = variables?[named] ?? 0
            cache.descriptionAccumulator = named
        }
        
        func performPendingBinaryOperation(){
            if pendingBinaryOperation != nil && cache.accumulator != nil {
                error = pendingBinaryOperation!.validate(with: cache.accumulator!)
                
                cache.accumulator = pendingBinaryOperation!.perform(with: cache.accumulator!)
                cache.descriptionAccumulator = pendingBinaryOperation!.performDescription(with: cache.descriptionAccumulator!)
                prevPriority = pendingBinaryOperation!.priority
                pendingBinaryOperation = nil
            }
        }
        
        func performOperation(_ symbol: String) {
            
            if let operation = operations[symbol] {
                
                switch operation {
                    
                case .constant(let value):
                    
                    cache.accumulator = value
                    cache.descriptionAccumulator = symbol
                    
                case .uanaryOperation (let function, var descFunction, let validator):
                    error = validator?(cache.accumulator!)
                    if cache.accumulator != nil {
                        cache.accumulator = function(cache.accumulator!)
                        
                        if descFunction == nil {
                            descFunction = {symbol + "(" + $0 + ")"} //standart description
                        }
                        
                        cache.descriptionAccumulator = descFunction!(cache.descriptionAccumulator!)
                        
                    }
                case .binaryOperation(let function, var descFunction, let validator, let priority):
                    
                    if resultIsPending  {
                        performPendingBinaryOperation()
                    }
                    
                    
                    if cache.accumulator != nil {
                        if descFunction == nil {
                            descFunction = {$0 + " " + symbol + " " + $1} //standart description
                        }
                        pendingBinaryOperation = PendingBinaryOperation(function: function,
                                                                        firstOperand: cache.accumulator!,
                                                                        descriptionFunction: descFunction!,
                                                                        descriptionOperand: cache.descriptionAccumulator!,
                                                                        validator : validator,
                                                                        priority : priority,
                                                                        prevPriority : prevPriority)
                        cache = (nil,nil)
                        
                    }
                case .nullaryOperation(let function, let descValue):
                    
                    cache.accumulator = function()
                    cache.descriptionAccumulator = descValue
                    
                case .equals:
                    
                    performPendingBinaryOperation()
                    
                }
            }
        }
        
        
        //
        // Master function BODY
        //
        
        guard !internalProgram.isEmpty else {return (nil,false," ",nil)}
        
        for op in internalProgram {
            switch op {
            case .operand(let operand):
                setOperand(operand)
            case .operation(let operation):
                performOperation(operation)
            case .variable(let symbol):
                setOperand(variable: symbol)
            }
        }
        
        return (result,resultIsPending,description ?? " ", error)
        
    } // MASTER FUNC END
    
    @available(iOS,deprecated, message: "Deprecated, no longer needed, use the func evaluate(...) instead" )
    var description: String? {
        get {
            return evaluate().Description
        }
    }
    
    @available(iOS,deprecated, message: "Deprecated, no longer needed, use the func evaluate(...) instead" )
    var resultIsPending: Bool {
        get {
            return evaluate().isPending
        }
    }
    
    @available(iOS,deprecated, message: "Deprecated, no longer needed, use the func evaluate(...) instead" )
    var result : Double? {
        get {
            return evaluate().result
        }
    }
    
} //STRUCTURE END

//calculate factorial function
func factorialCalc(digit : Double) -> Double {
    var n = Int(digit)
    var result = 1
    
    while n > 1 {
        result *= n
        n -= 1
    }
    return Double(result)
}

