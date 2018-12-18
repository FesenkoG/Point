//
//  PointViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 08/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit
import Starscream
import CoreLocation

class PointViewController: UIViewController {
    
    // MARK: - Private properties
    
    @IBOutlet private weak var buttonView: UIView!
    @IBOutlet private weak var waitCircle: UIImageView!
    @IBOutlet private weak var pointButton: UIButton!
    @IBOutlet private weak var helperTextLabel: UILabel!

    private var locationService: ILocationService = LocationService()
    private let localStorage: ILocalStorage = LocalStorage()
    private var currentLocation: Location?
    private var isConnected: Bool = false
    
    
    // MARK: - Public properties
    
    var socket: WebSocket!
    var animate: Bool = false
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waitCircle.rotate360Degrees()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pointButton.layer.cornerRadius = pointButton.bounds.height / 2
        pointButton.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.4039215686, blue: 0.5764705882, alpha: 1)
    }
    
    
    // MARK: - Private methods
    
    @IBAction private func pointButtonTapped(_ sender: UIButton) {
        
        if locationService.isPermissionObtained {
            startAnimation()
        } else {
            locationService.requestPermission()
        }
    }
    
    func changeAnimationState() {
        animate = !animate
        waitCircle.isHidden = animate
        helperTextLabel.isHidden = !helperTextLabel.isHidden
    }
    
    func turnAnimationOn() {
        animate = true
        
    }
    
    private func startAnimation() {
        
        changeAnimationState()

        if !animate {
            socket?.disconnect()
            locationService.stopUpdatingLocation()
        } else {
            locationService.delegate = self
            currentLocation = nil
            isConnected = false
            locationService.startUpdatingLocation()
        }
        
        
        animateButton(pointButton, animate: animate, withInterval: 2.5)
    }
    
    private func animateButton(_ button: UIButton, animate: Bool, withInterval interval: Double) {
        let delay = interval / 4
        if animate {
            let (view, transform) = getViewAndTransform(view: button)
            let (view2, transform2) = getViewAndTransform(view: button)
            let (view3, transform3) = getViewAndTransform(view: button)
            let (view4, transform4) = getViewAndTransform(view: button)
            UIView.animate(withDuration: interval, delay: 0, options: .allowUserInteraction, animations: {
                view.transform = transform
                view.alpha = 0.0
                UIView.animate(withDuration: interval, delay: delay, options: .allowUserInteraction, animations: {
                    view2.transform = transform2
                    view2.alpha = 0.0
                }, completion: { (_) in
                    view2.removeFromSuperview()
                })
                UIView.animate(withDuration: interval, delay: delay * 2, options: .allowUserInteraction, animations: {
                    view3.transform = transform3
                    view3.alpha = 0.0
                }, completion: { (_) in
                    view3.removeFromSuperview()
                })
                UIView.animate(withDuration: interval, delay: delay * 3, options: .allowUserInteraction, animations: {
                    view4.transform = transform4
                    view4.alpha = 0.0
                }, completion: { (_) in
                    view4.removeFromSuperview()
                })
            }) { (_) in
                view.removeFromSuperview()
                self.animateButton(button, animate: self.animate, withInterval: interval)
            }
        }
        
    }
    
    private func getViewAndTransform(view: UIButton) -> (view: UIView, transform: CGAffineTransform) {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let transformedView = UIView(frame: frame)
        transformedView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.4039215686, blue: 0.5764705882, alpha: 1)
        transformedView.layer.cornerRadius = transformedView.bounds.height / 2
        let originalTransform = transformedView.transform
        let scaledTransform = originalTransform.scaledBy(x: 2.0, y: 2.0)
        transformedView.alpha = 0.6
        view.addSubview(transformedView)
        return (transformedView, scaledTransform)
    }
    
}


// MARK: - LocationServiceDelegate
extension PointViewController: LocationServiceDelegate {
    
    func didChangeStatus(isAuthorized: Bool) {
        if isAuthorized {
            startAnimation()
        }
    }
    
    func didChangeLocation(_ newLocation: Location) {
        if currentLocation == nil {
            currentLocation = newLocation
            guard let token = localStorage.getUserToken() else { return }
            guard let url = URL(string: "\(SOCKET_URL)/search?token=\(token)&longitude=\(newLocation.longitude)&latitude=\(newLocation.latitude)") else { return }
            socket = WebSocket(url: url)
            socket.delegate = self
            socket.connect()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.isConnected = true
//            }
        } else {
            if isConnected {
                locationService.updateUserLocation(latitude: newLocation.latitude, longitude: newLocation.longitude) { (error) in
                    if let error = error {
                        self.showErrorAlert(error)
                    }
                }
            }
        }
        
    }
}


// MARK: - WebSocketDelegate
extension PointViewController: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        self.isConnected = true
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let error = error {
            self.showErrorAlert(error.localizedDescription)
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print(text)
        do {
            guard let data = text.data(using: .utf8) else { return }
            guard var json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else { return }
            guard let id = json["id"] else { return }
            print(id)
            json["id"] = nil
            print(json)
            let dataToDecode = try JSONSerialization.data(withJSONObject: json as Any, options: [])
            let user = try JSONDecoder().decode(UserData.self, from: dataToDecode)
            let matchViewController = MatchViewController(userID: id, user: user, socket: self.socket)
            matchViewController.pointViewController = self
            
            matchViewController.modalPresentationStyle = .overCurrentContext
            matchViewController.modalTransitionStyle = .crossDissolve
            
            self.present(matchViewController, animated: true, completion: nil)
        } catch {
            print(error)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print(data)
    }
}
