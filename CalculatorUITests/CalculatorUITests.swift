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


let calcFormatter = CalculatorFormatter()


class CalculatorUITests: XCTestCase {
    
    
    let app = XCUIApplication()
    var buttonDict : [String : XCUIElement] = [:]
    //let calcFormatter = CalculatorFormatter()
    
    let point =  calcFormatter.decimalSeparator ?? "."
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
       // app = XCUIApplication()
        
        buttonDict = [
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
            "C"     :   app.buttons["C"],
            "⌫"    :   app.buttons["⌫"],
            point   :   app.buttons[point],
            "→M"    :   app.buttons["→M"],
            "M"     :   app.buttons["M"]
        ]
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    
    
    func testGeneral() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        
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
        
        
        // (111 111 111)² = 12345678987654320
        
        buttonDict["x²"]?.tap()
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 12345678987654320)) {
            XCTAssert(app.staticTexts[pendingResult].exists)
        }
        
        // √12345678987654320 = 111111111
        buttonDict["√"]?.tap()
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 111111111)) {
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
    
    
    
    
    func testBackspace() {
        
        //simple backspace check
        
        buttonDict["C"]?.tap()
        
        buttonDict["9"]?.tap()
        buttonDict["3"]?.tap()
        buttonDict["4"]?.tap()
        buttonDict["7"]?.tap()
        buttonDict["8"]?.tap()
        buttonDict["3"]?.tap()
        buttonDict["4"]?.tap()
       
        
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 9347834)) {
            XCTAssert(app.staticTexts[pendingResult].exists)
        }
        
        buttonDict["⌫"]?.tap()
        
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 934783)) {
            XCTAssert(app.staticTexts[pendingResult].exists)
        }

        buttonDict["⌫"]?.tap()
        
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 93478)) {
            XCTAssert(app.staticTexts[pendingResult].exists)
        }
        
        buttonDict["9"]?.tap()
        buttonDict["9"]?.tap()
        
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 9347899)) {
            XCTAssert(app.staticTexts[pendingResult].exists)
        }

        buttonDict["⌫"]?.tap()
        
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 934789)) {
            XCTAssert(app.staticTexts[pendingResult].exists)
        }
        
        // backspace in the middle operation
        
        buttonDict["+"]?.tap()
        buttonDict["5"]?.tap()
        buttonDict["5"]?.tap()
        buttonDict["7"]?.tap()
        buttonDict["2"]?.tap()
        buttonDict["9"]?.tap()
        buttonDict["0"]?.tap()
        
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 557290)) {
            XCTAssert(app.staticTexts[pendingResult].exists)
        }

        buttonDict["⌫"]?.tap()
        
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 55729)) {
            XCTAssert(app.staticTexts[pendingResult].exists)
        }

        buttonDict["⌫"]?.tap()
        
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 5572)) {
            XCTAssert(app.staticTexts[pendingResult].exists)
        }
        
        buttonDict["3"]?.tap()
        buttonDict["7"]?.tap()
        
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 557237)) {
            XCTAssert(app.staticTexts[pendingResult].exists)
        }
        
        buttonDict["="]?.tap()
        
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 1492026)) {
            XCTAssert(app.staticTexts[pendingResult].exists)
        }
        
        buttonDict["⌫"]?.tap()
        buttonDict["⌫"]?.tap()
        
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 557237)) {
            XCTAssert(app.staticTexts[pendingResult].exists)
        }
        
        buttonDict["+"]?.tap()
        buttonDict["2"]?.tap()
        buttonDict["5"]?.tap()
        buttonDict["6"]?.tap()
        
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 256)) {
            XCTAssert(app.staticTexts[pendingResult].exists)
        }
        
        buttonDict["⌫"]?.tap()
        
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 25)) {
            XCTAssert(app.staticTexts[pendingResult].exists)
        }
        
        buttonDict["="]?.tap()
        
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 934814)) {
            XCTAssert(app.staticTexts[pendingResult].exists)
        }
    }
    
    func testDecimalPoint() {
        
        
        buttonDict["C"]?.tap()
        
        //Allow decimal point
        
        buttonDict["2"]?.tap()
        XCTAssert(app.staticTexts["2"].exists)
        
        buttonDict["4"]?.tap()
        XCTAssert(app.staticTexts["24"].exists)
        
        
        buttonDict[point]?.tap()
        XCTAssert(app.staticTexts["24"+point].exists)
        
        buttonDict["1"]?.tap()
        XCTAssert(app.staticTexts["24"+point+"1"].exists)
        
        buttonDict["9"]?.tap()
        XCTAssert(app.staticTexts["24"+point+"19"].exists)
        
        
        buttonDict["+"]?.tap()
        XCTAssert(app.staticTexts["24"+point+"19"].exists)
        
        buttonDict["7"]?.tap()
        XCTAssert(app.staticTexts["7"].exists)
        
        buttonDict["3"]?.tap()
        XCTAssert(app.staticTexts["73"].exists)
        
        
        buttonDict[point]?.tap()
        XCTAssert(app.staticTexts["73"+point].exists)
        
        buttonDict["5"]?.tap()
        XCTAssert(app.staticTexts["73"+point+"5"].exists)
        
        buttonDict["4"]?.tap()
        XCTAssert(app.staticTexts["73"+point+"54"].exists)
        
        buttonDict["="]?.tap()
        XCTAssert(app.staticTexts["97"+point+"73"].exists)
        
        //Check correcting formatter !during! inputing a number with decimal point.
        //Input 93478,34553, expect: 93 478,34553 or 93,478.34553 - depending from locale settings
        
        buttonDict["C"]?.tap()
        
        XCTAssert(app.staticTexts["0"].exists)
        
        buttonDict["9"]?.tap()
        buttonDict["3"]?.tap()
        buttonDict["4"]?.tap()
        buttonDict["7"]?.tap()
        buttonDict["8"]?.tap()
        buttonDict[point]?.tap()
        buttonDict["3"]?.tap()
        buttonDict["4"]?.tap()
        buttonDict["5"]?.tap()
        buttonDict["5"]?.tap()
        buttonDict["3"]?.tap()
        
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 93478.34553)) {
            XCTAssert(app.staticTexts[pendingResult].exists)
        }
        
        //only allow 1 decimal point
        
        buttonDict["C"]?.tap()
        
        XCTAssert(app.staticTexts["0"].exists)
        
        buttonDict["9"]?.tap()
        buttonDict["3"]?.tap()
        buttonDict["4"]?.tap()
        buttonDict["7"]?.tap()
        buttonDict["8"]?.tap()
        buttonDict[point]?.tap()
        buttonDict["3"]?.tap()
        buttonDict["4"]?.tap()
        buttonDict[point]?.tap()
        buttonDict["5"]?.tap()
        buttonDict["5"]?.tap()
        buttonDict[point]?.tap()
        buttonDict["3"]?.tap()
        buttonDict[point]?.tap()
        
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 93478.34553)) {
            XCTAssert(app.staticTexts[pendingResult].exists)
        }
        
        //User starts off entering a new number by touching the decimal point 
        // Input ".36 + .78", expect 1,14
        
        buttonDict["C"]?.tap()
        
        buttonDict[point]?.tap()
        XCTAssert(app.staticTexts["0"+point].exists)
        buttonDict["3"]?.tap()
        XCTAssert(app.staticTexts["0"+point+"3"].exists)
        buttonDict["6"]?.tap()
        XCTAssert(app.staticTexts["0"+point+"36"].exists)
        buttonDict["+"]?.tap()
        buttonDict[point]?.tap() // IT IS VERY IMPORTANT TEST!!
        XCTAssert(app.staticTexts["0" + point].exists)
        buttonDict["7"]?.tap()
        XCTAssert(app.staticTexts["0"+point+"7"].exists)
        buttonDict["8"]?.tap()
        XCTAssert(app.staticTexts["0"+point+"78"].exists)
        buttonDict["="]?.tap()
        XCTAssert(app.staticTexts["1"+point+"14"].exists)
        
        
        //check input affter prevois test-case
        //input "C 327891"  expect "32,7891", now I get "0327891"
        
        buttonDict["3"]?.tap()
        buttonDict["2"]?.tap()
        buttonDict["7"]?.tap()
        buttonDict["8"]?.tap()
        buttonDict["9"]?.tap()
        buttonDict["1"]?.tap()
        if let pendingResult = calcFormatter.string(from: NSNumber(value: 327891)) {
            XCTAssert(app.staticTexts[pendingResult].exists)
        }
        
    }
    
    func testMemo() {
        
        
        buttonDict["C"]?.tap()
        
        // 9 +  M = √ ⇒ description имеет вид √(9+M), display показывает 3, так как M не установлена (то есть равна 0)
        
        buttonDict["9"]?.tap()
        buttonDict["+"]?.tap()
        buttonDict["M"]?.tap()
        buttonDict["="]?.tap()
        buttonDict["√"]?.tap()
        XCTAssert(app.staticTexts["√(9 + M) ="].exists)
        XCTAssert(app.staticTexts["3"].exists)
    
        
        // 7 →M >⇒ display теперь показывает 4 (квадратный корень 16), description все еще показывает √(9+M)
        
        buttonDict["7"]?.tap()
        buttonDict["→M"]?.tap()
        XCTAssert(app.staticTexts["√(9 + M) ="].exists)
        XCTAssert(app.staticTexts["4"].exists)
        XCTAssert(app.staticTexts["7"].exists)
        //+14  = ⇒ display показывает 18, description теперь √(9+M)+14
        
        buttonDict["+"]?.tap()
        buttonDict["1"]?.tap()
        buttonDict["4"]?.tap()
        buttonDict["="]?.tap()
        XCTAssert(app.staticTexts["√(9 + M) + 14 ="].exists)
        XCTAssert(app.staticTexts["18"].exists)
        XCTAssert(app.staticTexts["7"].exists)
    
        
    }

    
    
}

