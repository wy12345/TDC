//
//  AnimationView.swift
//  TDC
//
//  Created by Wilson Yan on 8/14/16.
//  Copyright © 2016 Wilson Yan. All rights reserved.
//

import UIKit

class AnimationView: UIView {
    var state = CellType.Open {
        didSet {
            setNeedsDisplay()
        }
    }
    enum CellType {
        case Open
        case Marked
        case Skipped
        case Today
    }
    
    var outlineRect: UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: bounds.size.width, y: 0))
        path.addLineToPoint(CGPoint(x: bounds.size.width, y: bounds.size.height))
        path.addLineToPoint(CGPoint(x: 0, y: bounds.size.height))
        path.closePath()
        
        path.lineWidth = 1
        
        return path
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
//        UIColor.lightGrayColor().setStroke()
//        UIColor.clearColor().setFill()
//        outlineRect.stroke()
        
        switch state {
        case .Marked: drawCheckMark()
        case .Skipped: drawX()
        case .Today: drawNeedToUpdateIcon()
        case .Open: break
        }
    }
    
    var blankPath: UIBezierPath {
        let path = UIBezierPath(rect: bounds)
        path.lineWidth = 5
        return path
    }
    
    var checkMarkPath: UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: bounds.size.width*0.1, y: bounds.size.height*0.5))
        path.addLineToPoint(CGPoint(x: bounds.size.width*0.4, y: bounds.size.height*0.8))
        path.addLineToPoint(CGPoint(x: bounds.size.width*0.9, y: bounds.size.height*0.1))
        
        path.lineWidth = 5
        return path
    }
    
    var xPath: UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: bounds.size.width*0.1, y: bounds.size.height*0.1))
        path.addLineToPoint(CGPoint(x: bounds.size.width*0.9, y: bounds.size.height*0.9))
        
        path.moveToPoint(CGPoint(x: bounds.size.width*0.1, y: bounds.size.height*0.9))
        path.addLineToPoint(CGPoint(x: bounds.size.width*0.9, y: bounds.size.height*0.1))
        
        path.lineWidth = 5
        return path
    }

    var updatePath: UIBezierPath {
        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.size.width/2, y: bounds.size.height/2), radius: min(bounds.size.width,bounds.size.height)/2*0.8, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = 5
        return path
    }
    
    func animateSelected() {
        state = .Open
        animateBezierPath(checkMarkPath, withColor: UIColor.greenColor().CGColor, withDuration: 0.3)
        animateBounceEffect()
    }
    
    private func animateBounceEffect() {
        let bounceAnimation = AnimationClass.BounceEffect()
        bounceAnimation(self) { [unowned self] (completed) in
            self.state = .Marked
        }
    }
    
    private func animateBezierPath(bezierPath: UIBezierPath, withColor color: CGColor, withDuration duration: CFTimeInterval) {
        let bezierLayer = CAShapeLayer()
        bezierLayer.backgroundColor = UIColor.whiteColor().CGColor
        bezierLayer.fillColor = nil
        
        bezierLayer.path = bezierPath.CGPath
        bezierLayer.lineWidth = 5.0
        bezierLayer.strokeColor = color
        bezierLayer.strokeStart = 0.0
        bezierLayer.strokeEnd = 1.0
        
        self.layer.addSublayer(bezierLayer)
        let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animateStrokeEnd.duration = duration
        animateStrokeEnd.fromValue = NSNumber(float: 0.0)
        animateStrokeEnd.toValue = NSNumber(float: 1.0)
        bezierLayer.addAnimation(animateStrokeEnd, forKey: "strokeEndAnimation")
    }
    
    func drawCheckMark() {
        UIColor.greenColor().setStroke()
        checkMarkPath.stroke()
    }
    
    func drawX() {
        UIColor.redColor().setStroke()
        xPath.stroke()
    }
    
    func drawNeedToUpdateIcon() {
        UIColor.blueColor().setStroke()
        updatePath.stroke()
    }
    
    func drawBlank() {
        UIColor.whiteColor().setFill()
        blankPath.fill()
    }

}
