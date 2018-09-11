//
//  MatchViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 11.08.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController {

    @IBOutlet weak var clockView: RoundedView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runAnimation()
    }
    
    private func runAnimation() {
        
        let witdh = clockView.bounds.width
        let height = clockView.bounds.height
        let forCurve: CGFloat = 10
        
        //Configure path
        let path = UIBezierPath()
        path.move(to: CGPoint(x: witdh / 2, y: 0))
        path.addLine(to: CGPoint(x: witdh - forCurve, y: 0))
        path.addCurve(to: CGPoint(x: witdh, y: forCurve), controlPoint1: CGPoint(x: witdh - 5, y: 0), controlPoint2: CGPoint(x: witdh, y: 5))
        path.addLine(to: CGPoint(x: witdh, y: height - forCurve))
        path.addCurve(to: CGPoint(x: witdh - forCurve, y: height), controlPoint1: CGPoint(x: witdh, y: height - 5), controlPoint2: CGPoint(x: witdh - 5, y: height))
        path.addLine(to: CGPoint(x: forCurve, y: height))
        path.addCurve(to: CGPoint(x: 0, y: height - forCurve), controlPoint1: CGPoint(x: 5, y: height), controlPoint2: CGPoint(x: 0, y: height - 5))
        path.addLine(to: CGPoint(x: 0, y: forCurve))
        path.addCurve(to: CGPoint(x: forCurve, y: 0), controlPoint1: CGPoint(x: 0, y: 5), controlPoint2: CGPoint(x: 5, y: 0))
        path.addLine(to: CGPoint(x: witdh / 2, y: 0))
        
        // create shape layer for that path
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.strokeColor = #colorLiteral(red: 0.9882352941, green: 0.5607843137, blue: 0.6666666667, alpha: 1).cgColor
        shapeLayer.lineWidth = 6
        shapeLayer.path = path.cgPath
        
        // animate it
        clockView.layer.addSublayer(shapeLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 20
        animation.delegate = self
        shapeLayer.add(animation, forKey: "MyAnimation")
    }
    
    
    //Those functions may be helpful in future
    func pauseAnimation(layer: CALayer){
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func resumeAnimation(layer: CALayer){
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    @IBAction func noButtonTapped(_ sender: Any) {
        pauseAnimation(layer: clockView.layer)
        
    }
    @IBAction func yesButtonTapped(_ sender: Any) {
        pauseAnimation(layer: clockView.layer)
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension MatchViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            dismiss(animated: true, completion: nil)
        }
    }
}
