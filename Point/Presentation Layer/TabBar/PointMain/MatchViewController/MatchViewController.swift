//
//  MatchViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 11.08.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit
import Starscream
import AlamofireImage

class MatchViewController: UIViewController {

    // MARK: - Private properties

    @IBOutlet private weak var clockView: RoundedView!
    @IBOutlet private weak var userPhotoImageView: CircleImage!
    @IBOutlet weak var circleAroundImageView: CircleAroundImage!
    @IBOutlet private weak var userNicknameAndAgeLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var userBioLabel: UILabel!
    
    lazy var genderColor: UIColor = {
        return matchedUser.myGender == "0" ? Colors.female.color() : Colors.male.color()
    }()
    // TODO: - Убрать userId - это будет в user хранится
    private let userID: String
    private let matchedUser: UserData
    private var socket: WebSocket
    private let imageService: IImageService = ImageService()
    
    
    // MARK: - Public properties
    
    weak var pointViewController: PointViewController?
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawSelf()
        userNicknameAndAgeLabel.text = matchedUser.nickname + ", " + DateHelper.convertTimestampToAge(Int(matchedUser.myAge) ?? 0)
        userBioLabel.text = matchedUser.myBio
        circleAroundImageView.strokeColor = genderColor
        
        guard let token = LocalStorage().getUserToken() else { return }
        let url = "\(BASE_URL)/getPhoto?&token=\(token)&userId=\(userID)"
        guard let imageUrl = URL(string: url) else { return }
        self.userPhotoImageView.layer.cornerRadius = self.userPhotoImageView.bounds.height / 2
        self.userPhotoImageView.clipsToBounds = true
        self.userPhotoImageView.af_setImage(withURL: imageUrl,
                                            placeholderImage: nil,
                                            filter: nil,
                                            progress: { (progress) in
                                                print(progress.fileCompletedCount)
        }, progressQueue: DispatchQueue.main,
           imageTransition: UIImageView.ImageTransition.crossDissolve(0.25),
           runImageTransitionIfCached: true) { (data) in
            print(data)
        }
    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        guard let token = LocalStorage().getUserToken() else { return }
//        let url = "\(BASE_URL)/getPhoto?&token=\(token)&userId=\(userID)"
//        guard let imageUrl = URL(string: url) else { return }
//        self.userPhotoImageView.layer.cornerRadius = self.userPhotoImageView.bounds.height / 2
//        self.userPhotoImageView.clipsToBounds = true
//        self.userPhotoImageView.af_setImage(withURL: imageUrl,
//                                            placeholderImage: nil,
//                                            filter: nil,
//                                            progress: { (progress) in
//            print(progress.fileCompletedCount)
//        }, progressQueue: DispatchQueue.main,
//           imageTransition: UIImageView.ImageTransition.crossDissolve(0.25),
//           runImageTransitionIfCached: true) { (data) in
//            print(data)
//        }
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runAnimation()
    }
    
    
    // MARK: - Initialization
    
    init(userID: String, matchedUser: UserData, socket: WebSocket) {
        self.userID = userID
        self.matchedUser = matchedUser
        self.socket = socket
        super.init(nibName: nil, bundle: nil)
        socket.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private methods
    
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
        path.close()
        
        // create shape layer for that path
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = genderColor.cgColor
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
    
    private func drawSelf() {
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
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        let color = genderColor.withAlphaComponent(0.4)
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 6
        shapeLayer.path = path.cgPath
        
        clockView.layer.addSublayer(shapeLayer)
    }
    
    
    //Those functions may be helpful in future
    private func pauseAnimation(layer: CALayer){
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    private func resumeAnimation(layer: CALayer){
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    @IBAction private func noButtonTapped(_ sender: UIButton) {
        //sender.isUserInteractionEnabled = false
        //pauseAnimation(layer: clockView.layer)
        animateHide(yesButton, message: "false")
        guard let pointViewController = pointViewController else { return }
        pointViewController.socket.delegate = pointViewController
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction private func yesButtonTapped(_ sender: UIButton) {
        //sender.isUserInteractionEnabled = false
        //pauseAnimation(layer: clockView.layer)
        animateHide(noButton, message: "true")
    }
    
    @IBAction private func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        pointViewController?.changeAnimationState()
        socket.disconnect()
    }

    private func animateHide(_ view: UIView, message: String) {
        
        UIView.animate(withDuration: 0.5, animations: {
            view.alpha = 0.0
        }) { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                view.isHidden = true
            }, completion: { [weak self] _ in
                self?.socket.write(string: message)
            })
        }
    }
    
}


// MARK: - CAAnimationDelegate
extension MatchViewController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            dismiss(animated: true, completion: nil)
        }
    }
}


// MARK: - WebSocketDelegate
extension MatchViewController: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print(socket)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let error = error {
            showErrorAlert(error.localizedDescription)
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let text = String(text.filter { !" \n\t\r".contains($0) })
        
        switch text {
        case "false", "Flase":
            guard let pointViewController = pointViewController else { return }
            pointViewController.socket.delegate = pointViewController
            self.dismiss(animated: false, completion: nil)
        default:
            guard let data = text.data(using: .utf8) else { return }
            do {
                let chat = try JSONDecoder().decode(Chat.self, from: data)
                guard let chatVC = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController else { return }
                chatVC.chat = chat
                chatVC.yourID = userID
                pointViewController?.changeAnimationState()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.pointViewController?.navigationController?.pushViewController(chatVC, animated: true)
                }
                
                self.dismiss(animated: false, completion: nil)
            } catch {
                showErrorAlert(error.localizedDescription)
            }

            
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print(data)
    }
}
