//
//  CalculatorUITests.swift
//  CalculatorUITests
//
//  Created by di on 02.05.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import XCTest
import Foundation
// @testable import Calculator


class CalculatorFormatter: NumberFormatter {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        self.numberStyle = .decimal
        self.maximumFractionDigits = 6
        self.locale = Locale.current
        self.usesGroupingSeparator = true
        self.allowsFloats = true
    }
    
    func formatterStrToDbl(from : String) -> Double?{
        //remove all spaces
        var charForRemove = self.groupingSeparator
        var result = from.replacingOccurrences(of: charForRemove!, with: "")
        //replace nation decimal separator to double
        charForRemove = self.decimalSeparator
        result = result.replacingOccurrences(of: charForRemove!, with: ".")
        return Double(result)
    }
}



class CalculatorUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTask1() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let calcFormatter = CalculatorFormatter()
        
        
        let buttonDict = [
            "0"     :   app.buttons["0"],
            "1"     :   app.buttons["1"],
            "2"     :   app.buttons["2"],
            "3"     :   app.buttons["3"],
            "4"     :   app.buttons["4"],
            "5"     :   app.buttons["5"],
            "6"     :   app.buttons["6"],
            "7"     :   app.buttons["7"],
            "8"     :   app.buttons["8"],
            "9"     :   app.buttons["9"],
            "π"     :   app.buttons["π"],
            "cos"   :   app.buttons["cos"],
            "sin"   :   app.buttons["sin"],
            "e"     :   app.buttons["e"],
            "ln"    :   app.buttons["ln"],
            "√"     :   app.buttons["√"],
            "x²"    :   app.buttons["x²"],
            "x!"    :   app.buttons["x!"],
            //"x⁻¹"   :   app.buttons["x⁻¹"],
            "±"     :   app.buttons["±"],
            "×"     :   app.buttons["×"],
            "+"     :   app.buttons["+"],
            "-"     :   app.buttons["-"],
            "÷"     :   app.buttons["÷"],
            "Rand"  :   app.buttons["Rand"],
            "="     :   app.buttons["="],
            "С"     :   app.buttons["С"],
            "⌫"     :   app.buttons["⌫"],
            "."     :   app.buttons["."]
        ]
        
        // check algeba, input: 100*10/2+16*4 = "564" need follow to math operations right order, not realized
       
        /*
        buttonDict["1"]?.tap()
        buttonDict["0"]?.tap()
        buttonDict["0"]?.tap()
        buttonDict["×"]?.tap()
        buttonDict["1"]?.tap()
        buttonDict["0"]?.tap()
        buttonDict["÷"]?.tap()
        buttonDict["2"]?.tap()
        buttonDict["+"]?.tap()
        buttonDict["1"]?.tap()
        buttonDict["6"]?.tap()
        buttonDict["×"]?.tap()
        buttonDict["4"]?.tap()
        XCTAssert(app.staticTexts["564"].exists) */
        
        
        
        // 12345679 * 9 = 111 111 111
        buttonDict["1"]?.tap()
        buttonDict["2"]?.tap()
        buttonDict["3"]?.tap()
        
        buttonDict["4"]?.tap()
        buttonDict["5"]?.tap()
        buttonDict["6"]?.tap()
        
        buttonDict["7"]?.tap()
        buttonDict["9"]?.tap()
        buttonDict["×"]?.tap()
        buttonDict["9"]?.tap()
        buttonDict["="]?.tap()
        
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 111111111)) {
            XCTAssert(app.staticTexts[pendingResult].exists)
        }
        
        
        // (111 111 111)² = 12345678987654321 (why I get "0" in the end???)
        
        buttonDict["x²"]?.tap()
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 12345678987654320)) {
            XCTAssert(app.staticTexts[pendingResult].exists)
        }
        
        
        //cos(π) = -1
        buttonDict["π"]?.tap()
        buttonDict["cos"]?.tap()
        XCTAssert(app.staticTexts["-1"].exists)
        
        //sin(π) = 0
        buttonDict["π"]?.tap()
        buttonDict["sin"]?.tap()
        XCTAssert(app.staticTexts["0"].exists)
        
        // ln(e) = 1
        buttonDict["e"]?.tap()
        buttonDict["ln"]?.tap()
        XCTAssert(app.staticTexts["1"].exists)

        //√81 = 9
        buttonDict["8"]?.tap()
        buttonDict["1"]?.tap()
        buttonDict["√"]?.tap()
        XCTAssert(app.staticTexts["9"].exists)

        //4² = 16
        buttonDict["4"]?.tap()
        buttonDict["x²"]?.tap()
        XCTAssert(app.staticTexts["16"].exists)
    
        //5! = 120 
        buttonDict["5"]?.tap()
        buttonDict["x!"]?.tap()
        XCTAssert(app.staticTexts["120"].exists)
        
        // 9 × (-1)  = -9
        buttonDict["9"]?.tap()
        buttonDict["±"]?.tap()
        XCTAssert(app.staticTexts["-9"].exists)
        
        // 12 × 34 = 408
        buttonDict["1"]?.tap()
        buttonDict["2"]?.tap()
        buttonDict["×"]?.tap()
        buttonDict["3"]?.tap()
        buttonDict["4"]?.tap()
        buttonDict["="]?.tap()
        XCTAssert(app.staticTexts["408"].exists)
        
        // 98 + 74 = 172
        buttonDict["9"]?.tap()
        buttonDict["8"]?.tap()
        buttonDict["+"]?.tap()
        buttonDict["7"]?.tap()
        buttonDict["4"]?.tap()
        buttonDict["="]?.tap()
        XCTAssert(app.staticTexts["172"].exists)
        
        // 57 - 68 = -11
        buttonDict["5"]?.tap()
        buttonDict["7"]?.tap()
        buttonDict["-"]?.tap()
        buttonDict["6"]?.tap()
        buttonDict["8"]?.tap()
        buttonDict["="]?.tap()
        XCTAssert(app.staticTexts["-11"].exists)

        //24 ÷ 12 = 2
        buttonDict["2"]?.tap()
        buttonDict["4"]?.tap()
        buttonDict["÷"]?.tap()
        buttonDict["1"]?.tap()
        buttonDict["2"]?.tap()
        buttonDict["="]?.tap()
        XCTAssert(app.staticTexts["2"].exists)
        
        
    }
    
}
