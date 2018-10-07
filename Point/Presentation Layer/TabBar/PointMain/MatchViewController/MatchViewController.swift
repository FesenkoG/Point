//
//  MatchViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 11.08.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit
import Starscream

class MatchViewController: UIViewController {

    @IBOutlet weak var clockView: RoundedView!
    
    @IBOutlet weak var userPhotoImageView: CircleImage!
    @IBOutlet weak var userNicknameAndAgeLabel: UILabel!
    @IBOutlet weak var userBioLabel: UILabel!
    // MARK: - Data for controller.
    let userID: String
    let user: UserData
    let socket: WebSocket
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO : - Do it
        //userPhotoImageView.image = UIImage(data: <#T##Data#>)
        //TODO : - convert myAge to real age, not date of birth
        if let imageData = Data(base64Encoded: user.image) {
            userPhotoImageView.image = UIImage(data: imageData)
        }
        userNicknameAndAgeLabel.text = user.nickname + ", " + user.myAge
        userBioLabel.text = user.myBio
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runAnimation()
    }
    
    init(userID: String, user: UserData, socket: WebSocket) {
        self.userID = userID
        self.user = user
        self.socket = socket
        super.init(nibName: nil, bundle: nil)
        socket.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = user.myGender == "0" ? Colors.female.color().cgColor : Colors.male.color().cgColor
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
        socket.write(string: "false")
        
    }
    @IBAction func yesButtonTapped(_ sender: Any) {
        pauseAnimation(layer: clockView.layer)
        socket.write(string: "true")
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        socket.disconnect()
    }
    
}

extension MatchViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            dismiss(animated: true, completion: nil)
        }
    }
}
