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

    // MARK: - Private properties

    @IBOutlet private weak var clockView: RoundedView!
    @IBOutlet private weak var userPhotoImageView: CircleImage!
    @IBOutlet private weak var userNicknameAndAgeLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var userBioLabel: UILabel!
    
    private let userID: String
    private let user: UserData
    private var socket: WebSocket
    private let imageService: IImageService = ImageService()
    
    
    // MARK: - Public properties
    
    weak var pointViewController: PointViewController?
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNicknameAndAgeLabel.text = user.nickname + ", " + DateHelper.convertTimestampToAge(Int(user.myAge) ?? 0)
        userBioLabel.text = user.myBio
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let token = LocalStorage().getUserToken() else { return }
        let url = "\(BASE_URL)/getPhoto?&token=\(token)&userId=\(userID)"
        
        imageService.loadImage(url) { [weak self] (result) in
            
            switch result {
            case .success(let image):
                self?.userPhotoImageView.image = image
            case .error(let error):
                self?.showErrorAlert(error)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //runAnimation()
    }
    
    
    // MARK: - Initialization
    
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
        animateHide(yesButton)
        socket.write(string: "false")
        guard let pointViewController = pointViewController else { return }
        pointViewController.socket.delegate = pointViewController
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction private func yesButtonTapped(_ sender: UIButton) {
        //sender.isUserInteractionEnabled = false
        //pauseAnimation(layer: clockView.layer)
        animateHide(noButton)
        socket.write(string: "true")
    }
    
    @IBAction private func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        pointViewController?.changeAnimationState()
        socket.disconnect()
    }

    private func animateHide(_ view: UIView) {
        
        UIView.animate(withDuration: 0.5, animations: {
            view.alpha = 0.0
        }) { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                view.isHidden = true
            })
        }
    }
    
}


// MARK: - CAAnimationDelegate
extension MatchViewController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        if flag {
//            dismiss(animated: true, completion: nil)
//        }
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
