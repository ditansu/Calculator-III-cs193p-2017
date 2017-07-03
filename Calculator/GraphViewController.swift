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
            
            
            restoreGrapthSettings()
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
            graphView?.Function = calcFunc
        }

    }
    
    
    
    private func updateUI() {
       function = calcFunc
    }
    
    
    private func saveGrapthSettings(){
        let  graphSettings = UserDefaults.standard
        graphSettings.set(graphView?.Origin.x, forKey: "graphOriginX")
        graphSettings.set(graphView?.Origin.y, forKey: "graphOriginY")
        graphSettings.set(graphView?.Scale, forKey: "Scale")
        
    }
    
    
    
    private func restoreGrapthSettings(){
        let  graphSettings = UserDefaults.standard
        if let graphOriginX = graphSettings.object(forKey: "graphOriginX") {
            graphView?.Origin.x = (graphOriginX as? CGFloat)!
        }
        
        if let graphOriginY = graphSettings.object(forKey: "graphOriginY") {
            graphView?.Origin.y = (graphOriginY as? CGFloat)!
        }
        
        if let pointsPerUnit = graphSettings.object(forKey: "Scale") {
            graphView?.Scale = (pointsPerUnit as? CGFloat)!
        }
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveGrapthSettings()
    }
    
    

}
