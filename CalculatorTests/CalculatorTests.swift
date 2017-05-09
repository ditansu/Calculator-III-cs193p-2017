//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by di on 28.04.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import XCTest

@testable import Calculator


class CalculatorTests: XCTestCase {
    
  
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
   
    func testSetOperand(){
        var testBrain = CalculatorBrain()
        testBrain.setOperand(5.0)
        XCTAssertEqual(testBrain.result, 5.0)
    }
    
    func testPerformOperation(){
        var testBrain = CalculatorBrain()
        
        testBrain.performOperation("π")
        testBrain.performOperation("cos")
        XCTAssertEqual(testBrain.result, -1.0)
        
        testBrain.setOperand(0.0)
        testBrain.performOperation("sin")
        XCTAssertEqual(testBrain.result, 0.0)
        
        testBrain.setOperand(1.0)
        testBrain.performOperation("cos⁻¹")
        XCTAssertEqual(testBrain.result, 0.0)
        
        testBrain.setOperand(1.0)
        testBrain.performOperation("sin⁻¹")
        XCTAssertEqual(testBrain.result, Double.pi/2)
        
        testBrain.performOperation("C")
        testBrain.performOperation("π")
        testBrain.performOperation("÷")
        testBrain.setOperand(4)
        testBrain.performOperation("=")
        testBrain.performOperation("tan")
        XCTAssertEqual(testBrain.result?.rounded(), 1.0)

        testBrain.setOperand(1.0)
        testBrain.performOperation("tan⁻¹")
        XCTAssertEqual(testBrain.result, Double.pi/4)

        
        testBrain.performOperation("e")
        testBrain.performOperation("ln")
        XCTAssertEqual(testBrain.result, 1.0)
        
        testBrain.setOperand(100)
        testBrain.performOperation("log")
        XCTAssertEqual(testBrain.result, 2)

        
        testBrain.setOperand(81)
        testBrain.performOperation("√")
        XCTAssertEqual(testBrain.result, 9.0)

        testBrain.setOperand(4)
        testBrain.performOperation("x²")
        XCTAssertEqual(testBrain.result, 16.0)
        
        testBrain.setOperand(2)
        testBrain.performOperation("xʸ")
        testBrain.setOperand(4)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.result, 16.0)
        
        testBrain.setOperand(5)
        testBrain.performOperation("x!")
        XCTAssertEqual(testBrain.result, 120.0)
        
        testBrain.setOperand(10)
        testBrain.performOperation("x⁻¹")
        XCTAssertEqual(testBrain.result, 0.1)

        testBrain.setOperand(123)
        testBrain.performOperation("±")
        XCTAssertEqual(testBrain.result, -123.0)

        testBrain.setOperand(5)
        testBrain.performOperation("×")
        testBrain.setOperand(4)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.result, 20.0)
        
        testBrain.setOperand(2)
        testBrain.performOperation("+")
        testBrain.setOperand(4)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.result, 6.0)
        
        testBrain.setOperand(6)
        testBrain.performOperation("-")
        testBrain.setOperand(4)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.result, 2.0)
        
        testBrain.setOperand(16)
        testBrain.performOperation("÷")
        testBrain.setOperand(4)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.result, 4.0)
        
    }
    
    func testResultIsPending(){
        var testBrain = CalculatorBrain()
        
        testBrain.setOperand(4.0)
        XCTAssertFalse(testBrain.resultIsPending)
        
        testBrain.performOperation("+")
        XCTAssertTrue(testBrain.resultIsPending)
        
        testBrain.setOperand(3.0)
        XCTAssertTrue(testBrain.resultIsPending)
        
        testBrain.performOperation("=")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 7.0)
    }
    
    func  testHint7(){
        /*
         7. Возможно, вы захотите добавить также вызов  performPendingBinaryOperation()  для case binaryOperation  (чтобы 6 x 5 x 4 x 3 = работало).
         */
        var testBrain = CalculatorBrain()
        
        testBrain.setOperand(6.0)
        XCTAssertFalse(testBrain.resultIsPending)
        
        testBrain.performOperation("×")
        XCTAssertTrue(testBrain.resultIsPending)
        
        testBrain.setOperand(5.0)
        XCTAssertTrue(testBrain.resultIsPending)

        testBrain.performOperation("×")
        XCTAssertTrue(testBrain.resultIsPending)
        
        testBrain.setOperand(4.0)
        XCTAssertTrue(testBrain.resultIsPending)

        testBrain.performOperation("×")
        XCTAssertTrue(testBrain.resultIsPending)
        
        testBrain.setOperand(3.0)
        testBrain.performOperation("=")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 360.0)
        
        
    }
    
    
    func testHistoryLog() {
        
        var testBrain = CalculatorBrain()
        
               
        //a. касаемся 7 + будет показано “7 + ...” ( 7, которая все еще на  display )
        testBrain.setOperand(7)
        testBrain.performOperation("+")
        XCTAssertEqual(testBrain.description, "7 + ")
        XCTAssertTrue(testBrain.resultIsPending)
        XCTAssertTrue(testBrain.result == nil)
        
        //b. 7 + 9 будет показано “7 + ...” (9 на  display )
        
        //c. 7 + 9 = будет показано “7 + 9 =” (16 на  display )
        testBrain.setOperand(9)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "7 + 9")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 16.0)
        
        //d. 7 + 9 = √ будет показано “√(7 + 9) =” (4 на  display )
        testBrain.performOperation("√")
        XCTAssertEqual(testBrain.description, "√(7 + 9)")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 4.0)
        
        // e. 7 + 9 = √ + 2 = будет показано “√(7 + 9) + 2 =” (6 на  display )
        
        testBrain.performOperation("+")
        testBrain.setOperand(2)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "√(7 + 9) + 2")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 6.0)
        
        //f. 7 + 9 √ будет показано “7 + √(9) ...” (3 на  display )

        testBrain.setOperand(7)
        testBrain.performOperation("+")
        testBrain.setOperand(9)
        testBrain.performOperation("√")
        XCTAssertEqual(testBrain.description, "7 + √(9)")
        XCTAssertTrue(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 3.0) 
 

        //g. 7 + 9 √ = будет показано “7 + √(9) =“ (10 на  display ) также проверяет корректность clear
        testBrain.performOperation("C")
        testBrain.setOperand(7)
        testBrain.performOperation("+")
        testBrain.setOperand(9)
        testBrain.performOperation("√")
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "7 + √(9)")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 10.0)
        
        //h. 7 + 9 = + 6= + 3 = будет показано “7 + 9 + 6 + 3 =” (25 на  display )

        testBrain.setOperand(7)
        testBrain.performOperation("+")
        testBrain.setOperand(9)
        testBrain.performOperation("=")
        testBrain.performOperation("+")
        testBrain.setOperand(6)
        testBrain.performOperation("=")
        testBrain.performOperation("+")
        testBrain.setOperand(3)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "7 + 9 + 6 + 3")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 25.0)
        
        //i. 7 + 9 = √ 6 + 3 = будет показано “6 + 3 =” (9 на  display )
        
        testBrain.setOperand(7)
        testBrain.performOperation("+")
        testBrain.setOperand(9)
        testBrain.performOperation("=")
        testBrain.performOperation("√")
        testBrain.setOperand(6)
        testBrain.performOperation("+")
        testBrain.setOperand(3)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "6 + 3")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 9.0)

        //j. 5 + 6 = 7 3 будет показано “5 + 6 =” (73 на  display )
        
        testBrain.setOperand(5)
        testBrain.performOperation("+")
        testBrain.setOperand(6)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "5 + 6")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 11.0)
        
        
        //k. 4 × π = будет показано “4 × π =“ (12.5663706143592 на  display )
        
        testBrain.setOperand(4)
        testBrain.performOperation("×")
        testBrain.performOperation("π")
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "4 × π")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertTrue(abs(testBrain.result! - 12.566370) < 0.0001)

    }
    
    func testMissingParenthesisBug(){
        var testBrain = CalculatorBrain()
        
        
        testBrain.setOperand(7)
        testBrain.performOperation("+")
        testBrain.setOperand(3)
        testBrain.performOperation("=")
        testBrain.performOperation("x²")
        XCTAssertEqual(testBrain.description, "(7 + 3)²")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 100.0)

        testBrain.setOperand(5)
        testBrain.performOperation("×")
        testBrain.setOperand(4)
        testBrain.performOperation("=")
        testBrain.performOperation("x⁻¹")
        XCTAssertEqual(testBrain.description, "(5 × 4)⁻¹")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertTrue((testBrain.result! - 0.05) < 0.0001)

        
    }
    
    
}
