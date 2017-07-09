//
//  GraphViewController.swift
//  Calculator
//
//  Created by di on 10.06.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    
    @IBOutlet weak var graphView: GraphView! {
     
        didSet {
           
            // Scale -- handled by GraphView
            let pinchHandler = #selector(graphView.changeScale(byReactionTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: graphView, action: pinchHandler)
            graphView.addGestureRecognizer(pinchRecognizer)
            
            // Move graph by panning
            let panHandler = #selector(graphView.moveGraphByPanning(byReactionTo:))
            let panRecognizer = UIPanGestureRecognizer(target: graphView, action: panHandler)
            graphView.addGestureRecognizer(panRecognizer)
            
            
            // Tap - set origin
            let tapHandler = #selector(graphView.setUserOriginByTAP(byReactionTo:))
            let tapRecognizer = UITapGestureRecognizer(target: graphView, action: tapHandler)
            tapRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(tapRecognizer)
            
            
            restoreGraphSettings()
            updateUI()
        }
    
        
    }
    
    private var calcFunc : ((Double)->Double?)? //= {$0*sin($0)}

    var function : ((Double)->Double?)?
    {
        get {
            return calcFunc
        }
        
        set {
            calcFunc = newValue
            graphView?.graphFunction = calcFunc
        }

    }
    
    private func updateUI() {
       function = calcFunc
    }
    
    
    
    private struct udKeys {
        static let Scale = "GraphView.Scale"
        static let OriginX = "GraphView.Origin.X"
        static let OriginY = "GraphView.Origin.Y"
    }
    
    private let ud = UserDefaults.standard
    
    private func saveGraphSettings(){
        let  graphOrigin = graphView!.alignment
        ud.set(graphOrigin.x, forKey: udKeys.OriginX)
        ud.set(graphOrigin.y, forKey: udKeys.OriginY)
        ud.set(graphView?.Scale, forKey: udKeys.Scale)
    }

    private func restoreGraphSettings(){
        var  graphOrigin = CGPoint.zero
        if let graphOriginX = ud.object(forKey: udKeys.OriginX) {
            graphOrigin.x = (graphOriginX as? CGFloat)!
        }
        
        if let graphOriginY = ud.object(forKey: udKeys.OriginY) {
            graphOrigin.y = (graphOriginY as? CGFloat)!
        }
        
        graphView?.alignment = graphOrigin
        
        if let Scale = ud.object(forKey: udKeys.Scale) {
            graphView?.Scale = (Scale as? CGFloat)!
        }
    }
    
    override func viewWillLayoutSubviews() {  // before rotate
        super.viewWillLayoutSubviews()
        graphView.originAlignment()
    }
    
// MARK: not need because  viewWillLayoutSubviews called twice (sic!) for one rotate: before & after rotate I don't know how 
//    override func viewDidLayoutSubviews() { // after
//        super.viewDidLayoutSubviews()
//        graphView.originAlignment()
//        print("viewDidLayoutSubviews called!!")
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //graphView.originAlignment() // call for user reset origin without rotation
        saveGraphSettings()
    }
    
    

}
