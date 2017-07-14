//
//  ViewController.swift
//  Calculator
//
//  Created by di on 18.04.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, UISplitViewControllerDelegate {
    
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var displayM: UILabel!
    
    @IBOutlet weak var buttonPoint: UIButton! {
        didSet {
            buttonPoint.setTitle(decimalSeparator, for: UIControlState())
        }
    }
    
    private var graphButtonActiveColor = UIColor.black
    
    @IBOutlet weak var graph: UIButton! {
        didSet {
            graph.isEnabled = false
            graphButtonActiveColor = graph.backgroundColor!
            graph.backgroundColor = UIColor.lightGray
        }
    }
    
    
    
    var userIsInTheMiddleOfTyping = false
    
    //MARK: MODEL {
    
    private var brain = CalculatorBrain()
    private var variables = [String:Double]()
   
    // }
    
    //MARK: Load\Restore MVC state by UserDefaults  {
   
    private let ud = UserDefaults.standard
    private struct Keys {
        static let Program = "CalcMVC.Program"
        //
    }
    
    private var program: PropertyList? {
        get { return ud.object(forKey: Keys.Program) as PropertyList? }
        set { ud.set(newValue, forKey: Keys.Program) }
    }

    private func saveState() -> Bool {
        guard !brain.evaluate(using: variables).isPending else {return false}
        program = brain.program
        return true
    }
    
    private func loadState() -> Bool {
        guard let savedProgram = program as? [Any] else {return false}
        brain.program = savedProgram as PropertyList
        displayResult = brain.evaluate(using: variables)
        return true
    }
    
    // }
    
    
    
    
    private let decimalSeparator = calcFormatter.decimalSeparator ?? "."
    
    var displayResult : (result : Double?, isPending : Bool, Description: String, error : String?) = (nil, false, " ",nil) {
        didSet {
            
            graph.isEnabled = !displayResult.isPending && displayResult.result != nil // "displayResult.result != nil" fix activate graphView with empty brain ;)
            graph.backgroundColor =  graph.isEnabled   ? graphButtonActiveColor : UIColor.lightGray
            
            
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
            display.text  = calcFormatter.string(from: NSNumber(value: doubleCurrentTotal))
            
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
    
    //MARK: -- Life Cycle
    
    override func awakeFromNib() {
        self.splitViewController?.delegate = self
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if loadState() {
            if  let graphVC = splitViewController?.viewControllers.last?.contentViewController as? GraphViewController {
                prepareGraphVC(to: graphVC)
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if saveState() {
            print("debug save ok")
        } else {
            print("debug don't save :(")
        }
        
    }
    
    
    
    //MARK: MANAGE SLAVE MVC
    
    private struct slaveMVC {
        static let GraphMVC = "GraphMVC"
    }
    
    //GraphMVC
    
    private func prepareGraphVC(to grapView : GraphViewController) {
        grapView.function = { [weak weakSelf = self] in return weakSelf?.brain.evaluate(using: ["M":$0]).result }
        grapView.navigationItem.title = displayResult.Description
        
    }
    
    //The graph button is pushed. Here we are preparing the GraphMVC to show the current function plot
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case slaveMVC.GraphMVC :
            var destinationViewController = segue.destination
            // get subView of NavigationController
            if let navigatonController = destinationViewController as? UINavigationController {
                destinationViewController = navigatonController.visibleViewController ?? destinationViewController
            }
            // try casting subView to GraphViewController and set function & title
            if let graphVC = destinationViewController as? GraphViewController {
                prepareGraphVC(to: graphVC)
            }
        //case slaveMVC.someSlaveMVC :
        default:
            return
        }
    }
    
    
    //Are we ready to show GraphView?
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        switch identifier {
        case slaveMVC.GraphMVC : return !brain.evaluate().isPending
        //case slaveMVC.someSlaveMVC : return... 
        default:
            return false
        }
        
    }
    
    
    //To doing master is a first visible view 
    
    
    private var isFirstStart = true
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        
        if isFirstStart {
            isFirstStart = false
            return true
        }
        
        return false
    }
    
}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
        
    }
}


