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
    private let shouldAnimate = ShouldAnimate()

    
    // MARK: - Public properties
    
    var socket: WebSocket!
    
    
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
    
    
    // MARK: - Public methods
    
    func changeAnimationState() {
        shouldAnimate.animate = !shouldAnimate.animate
        waitCircle.isHidden = shouldAnimate.animate
        helperTextLabel.isHidden = !helperTextLabel.isHidden
        if !shouldAnimate.animate {
            locationService.stopUpdatingLocation()
        } else {
            locationService.startUpdatingLocation()
        }
    }
    
    
    // MARK: - Private methods
    
    @IBAction private func pointButtonTapped(_ sender: UIButton) {
        
        if locationService.isPermissionObtained {
            startAnimation()
        } else {
            locationService.requestPermission()
        }
    }
    
    private func startAnimation() {
        
        changeAnimationState()

        if !shouldAnimate.animate {
            socket?.disconnect()
            locationService.stopUpdatingLocation()
        } else {
            locationService.delegate = self
            currentLocation = nil
            isConnected = false
            locationService.startUpdatingLocation()
        }
        
        recursivelyAnimate(shouldAnimate, sender: pointButton, duration: 4.0, numberOfAnimationsInTheRow: 5)
    }
    
    private func recursivelyAnimate(_ shouldAnimate: ShouldAnimate,
                                    sender: UIButton,
                                    duration: Double,
                                    numberOfAnimationsInTheRow: Int = 6) {
        if shouldAnimate.animate {
            let (view, transformation) = getViewAndTransform(view: sender)
            let delay = duration / Double(numberOfAnimationsInTheRow)
            UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .curveLinear], animations: {
                view.transform = transformation
                view.alpha = 0.0
                
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    self.recursivelyAnimate(shouldAnimate, sender: sender, duration: duration, numberOfAnimationsInTheRow: numberOfAnimationsInTheRow)
                })
                
            }) { (_) in
                view.removeFromSuperview()
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
        do {
            guard let data = text.data(using: .utf8) else { return }
            guard var json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else { return }
            // Получаем айдишник пользователя, к которому хотим подконнектиться
            // TODO: - Убрать это поле в дальнейшем
            guard let id = json["id"] else { return }
            json["id"] = nil
            let dataToDecode = try JSONSerialization.data(withJSONObject: json as Any, options: [])
            let matchedUser = try JSONDecoder().decode(UserData.self, from: dataToDecode)
            let matchViewController = MatchViewController(userID: id,
                                                          matchedUser: matchedUser,
                                                          socket: self.socket)
            matchViewController.pointViewController = self
            
            matchViewController.modalPresentationStyle = .overCurrentContext
            matchViewController.modalTransitionStyle = .coverVertical
            
            self.present(matchViewController, animated: true, completion: nil)
        } catch {
            showErrorAlert(error.localizedDescription)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        // TODO: - Don't know what it is
    }
}


class ShouldAnimate {
    var animate: Bool = false
}
