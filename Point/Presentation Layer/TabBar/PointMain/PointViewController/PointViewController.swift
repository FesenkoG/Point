//
//  PointViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 08/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit
import Starscream

class PointViewController: UIViewController {
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var waitCircle: UIImageView!
    @IBOutlet weak var pointButton: UIButton!
    @IBOutlet weak var helperTextLabel: UILabel!
    
    var socket: WebSocket!
    var locationService: ILocationService = LocationService()
    let localStorage: ILocalStorage = LocalDataStorage()
    var animate: Bool = false
    var currentLocation: Location?
    var isConnected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        waitCircle.rotate360Degrees()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pointButton.layer.cornerRadius = pointButton.bounds.height / 2
        pointButton.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.4039215686, blue: 0.5764705882, alpha: 1)
    }
    
    @IBAction func pointButtonTapped(_ sender: UIButton) {
        animate = !animate
        waitCircle.isHidden = animate
        if !animate {
            
            socket.disconnect()
            locationService.stopUpdatingLocation()
        } else {
            locationService.delegate = self
            currentLocation = nil
            isConnected = false
            locationService.startUpdatingLocation()
        }
        
        helperTextLabel.isHidden = !helperTextLabel.isHidden
        
        
        // Ask user's permission for location management and then check his answer.
        // In case of positive - start handling location and open the socket.
        // Every time user steps 100 meters away from previous location renew the location.
        animateButton(sender: sender, animate: animate, withInterval: 2.5)
    }
    
    private func animateButton(sender: UIButton, animate: Bool, withInterval interval: Double) {
        let delay = interval / 4
        if animate {
            let (view, transform) = getViewAndTransform(sender: sender)
            let (view2, transform2) = getViewAndTransform(sender: sender)
            let (view3, transform3) = getViewAndTransform(sender: sender)
            let (view4, transform4) = getViewAndTransform(sender: sender)
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
                self.animateButton(sender: sender, animate: self.animate, withInterval: interval)
            }
        }
        
    }
    
    private func getViewAndTransform(sender: UIButton) -> (view: UIView, transform: CGAffineTransform) {
        let frame = CGRect(x: 0, y: 0, width: sender.frame.width, height: sender.frame.height)
        let view = UIView(frame: frame)
        view.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.4039215686, blue: 0.5764705882, alpha: 1)
        view.layer.cornerRadius = view.bounds.height / 2
        let originalTransform = view.transform
        let scaledTransform = originalTransform.scaledBy(x: 2.0, y: 2.0)
        view.alpha = 0.6
        sender.addSubview(view)
        return (view, scaledTransform)
    }
    
}

extension PointViewController: LocationServiceDelegate {
    func didChangeStatus(isAuthorized: Bool) {
        
    }
    
    func didChangeLocation(_ newLocation: Location) {
        if currentLocation == nil {
            currentLocation = newLocation
            guard let token = localStorage.getUserToken() else { return }
            guard let url = URL(string: "\(SOCKET_URL)/search?token=\(token)&longitude=\(newLocation.longitude)&latitude=\(newLocation.latitude)") else { return }
            socket = WebSocket(url: url)
            socket.delegate = self
            socket.connect()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.isConnected = true
            }
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


extension PointViewController: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print(socket)
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
            matchViewController.pointNavigation = navigationController
            
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
