//
//  CalculatorUITests.swift
//  CalculatorUITests
//
//  Created by di on 02.05.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import XCTest

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
        
        buttonDict["π"]?.tap()
        buttonDict["cos"]?.tap()
        XCTAssert(app.staticTexts["-1"].exists)
        
        
        
        
    }
    
}
