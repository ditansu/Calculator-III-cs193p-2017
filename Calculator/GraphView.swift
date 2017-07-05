//
//  GraphView.swift
//  Calculator
//
//  Created by di on 10.06.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    @IBInspectable var Scale                    : CGFloat = 180             { didSet { self.setNeedsDisplay() }}
    @IBInspectable var MinimumPointsPerHashmark : CGFloat = 10              { didSet { self.setNeedsDisplay() }}
    @IBInspectable var GraphLineWidth           : CGFloat = 2.0             { didSet { self.setNeedsDisplay() }}
    @IBInspectable var AxesColor                : UIColor = UIColor.blue    { didSet { self.setNeedsDisplay() }}
    @IBInspectable var FunctionColor            : UIColor = UIColor.black   { didSet { self.setNeedsDisplay() }}
    
    
    // Bounds & origin
    
    // Activate after TAP gesture
    
    
    private var baseOrigin = CGPoint.zero
    
    
    var graphBounds : CGRect {
        return bounds //CGRect(x: bounds.minX+5, y: bounds.minY+20, width: bounds.width-10, height: bounds.height-40)
    }
    
    private var graphCenter : CGPoint {
        return convert(center, to: superview)
    }
    
    
    var graphOrigin : CGPoint  {
        
        get {
            var result = baseOrigin
            result.x += graphCenter.x
            result.y += graphCenter.y
            return result
        }
        
        set {
            var result = newValue
            result.x -= graphCenter.x
            result.y -= graphCenter.y
            baseOrigin = result
            self.setNeedsDisplay()
        }
        
    }
    
    
    //Heart of View
    var graphFunction : ((Double)->Double?)?  { didSet { self.setNeedsDisplay() }}
    
    
    // Axes
    private var axes = AxesDrawer()
    
    
    // Func draw
    private func getFuncPath(function graphFunc : (Double)->Double?, use step : CGFloat, in graphBounds : CGRect, origin graphOrigin : CGPoint, scale graphScale : CGFloat)->UIBezierPath {
        
        
        func alignedPoint(point : CGPoint) -> CGPoint {
            return  CGPoint(x: graphOrigin.x + point.x * graphScale,  y: graphOrigin.y - point.y * graphScale)
        }
        
        
        let funcPath = UIBezierPath()
        var x = -graphOrigin.x
        var isStartPoint = true
        //var iter = Int(0)
        
        while x <= graphBounds.width {
            
            x += step
            
            let y = graphFunc(Double(x))!
            
            let point = alignedPoint(point: CGPoint(x: x, y: CGFloat(y)))
          
            guard abs(point.y) < graphBounds.height*1.5 else {
                isStartPoint = true
                continue
            }
            
            //iter += 1
            
            if isStartPoint {
                funcPath.move(to: point)
                isStartPoint = false
            } else {
                funcPath.addLine(to: point)
            }
        }
        
        //print("Debug Iter count: \(iter)")
        return funcPath
    }
    

    
    override func draw(_ rect: CGRect) {
        
        axes.contentScaleFactor = self.contentScaleFactor
        axes.color = AxesColor
        axes.drawAxes(in: graphBounds, origin: graphOrigin, pointsPerUnit: Scale)
        
        guard let funcGraph = graphFunction else { return }
        let step = CGFloat(contentScaleFactor/graphBounds.width)*10
        let Graph = getFuncPath(function: funcGraph, use: step, in: graphBounds, origin: graphOrigin, scale: Scale)
        
        FunctionColor.set()
        Graph.lineWidth = GraphLineWidth
        Graph.stroke()
        
    }
    

//This is grapthOrigin alignment after iDevice rotate
    
    private var tempWidth : CGFloat = 0.0
    private var alignment = CGPoint.zero
    
    var alignedGraphOrign : CGPoint {
    
        get {
            return CGPoint(x: alignment.x * graphBounds.size.width,
                           y: alignment.y * graphBounds.size.height)
        
        }
        set {
            alignment.x = newValue.x / graphBounds.size.width
            alignment.y = newValue.y / graphBounds.size.height
        }
    
    }
    
    func setAligmentOrign(){
        alignedGraphOrign = graphOrigin
        tempWidth = graphBounds.size.width
    }
    
    func getAligmentOrign(){
        //if graphBounds.size.width != tempWidth {
            graphOrigin = alignedGraphOrign
        //}
    }
    
    
// Gestures handlers
    
    
    func changeScale(byReactionTo pinchRecognizer: UIPinchGestureRecognizer) {
        
        switch pinchRecognizer.state {
            
        case .changed, .ended:
            Scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1
        default:
            break
        }
        
    }
    
    func setUserOriginByTAP(byReactionTo tapRecognizer : UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let point = tapRecognizer.location(in: self)
            graphOrigin = point
        }
    }
    
    
    func moveGraphByPanning(byReactionTo panRecognizer : UIPanGestureRecognizer) {
        
        switch panRecognizer.state {
            
        case .changed, .ended:
            let point = panRecognizer.translation(in: self)
            var newOrigin = graphOrigin
            newOrigin.x += point.x
            newOrigin.y += point.y
            graphOrigin = newOrigin
            panRecognizer.setTranslation(CGPoint.zero, in: self)
        default:
            break
        }
    }
    
    
    
    
    
    
    
}





