//
//  CalculatorFormatter.swift
//  Calculator
//
//  Created by di on 21.04.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import Foundation

let calcFormatter = CalculatorFormatter()

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
