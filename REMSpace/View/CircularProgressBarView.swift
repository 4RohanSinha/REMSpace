//
//  CircularProgressBarView.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/6/23.
//

import UIKit

class CircularProgressBarView: UIView {
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    
    private var progressValue_: Float = 0.0
    
    public var progressValue: Float {
        get {
            return progressValue_
        }
        
        set {
            circleLayer.removeFromSuperlayer()
            progressLayer.removeFromSuperlayer()
            progressValue_ = newValue
            circleLayer = CAShapeLayer()
            progressLayer = CAShapeLayer()
            createCircularPath()
            //MARK: edit view
        }
    }
    
    private var startPoint = CGFloat(-Double.pi/2)
    
    private var endPoint: CGFloat {
        return startPoint+CGFloat(2*progressValue_*Float.pi)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createCircularPath()
    }
    
    func createCircularPath() {
       
        let circle = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: frame.size.width/3.0, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        //let circle = UIBezierPath(arcCenter: CGPoint.zero, radius: 80, startAngle: startPoint, endAngle: endPoint, clockwise: true)

        circleLayer.path = circle.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 10.0
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.clear.cgColor
        layer.addSublayer(circleLayer)
        
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.path = circle.cgPath
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 5.0
        progressLayer.strokeEnd = 1.0
        progressLayer.strokeColor = UIColor.systemIndigo.cgColor
        layer.addSublayer(progressLayer)
    }

}
