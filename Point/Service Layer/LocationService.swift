//
//  LocationService.swift
//  Point
//
//  Created by Георгий Фесенко on 20.10.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit
import CoreLocation

protocol ILocationService {
    var delegate: LocationServiceDelegate? { get set }
    var isPermissionObtained: Bool { get }
    
    func updateUserLocation(latitude: String, longitude: String, completion: @escaping (String?) -> Void)
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func requestPermission()
    
}

protocol LocationServiceDelegate: class {
    func didChangeStatus(isAuthorized: Bool)
    func didChangeLocation(_ newLocation: Location)
    func showChangeSettingsAlert()
}

class LocationService: NSObject, ILocationService {
    
    private let locationManager: CLLocationManager
    private let requestSender: IRequestSender
    private let localStorage: ILocalStorage
    
    weak var delegate: LocationServiceDelegate?
    
    override init() {
        locationManager = CLLocationManager()
        
        requestSender = RequestSender()
        localStorage = LocalStorage()
        
        super.init()
        
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 100.0
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func updateUserLocation(latitude: String, longitude: String, completion: @escaping (String?) -> Void) {
        guard let token = localStorage.getUserToken() else {
            completion("can not fetch user token")
            return
        }
        let config = RequestFactory.LocationRequests.getChangeLocationConfig(token: token, location: Location.init(longitude: longitude, latitude: latitude))
        
        requestSender.send(config: config) { (result) in
            switch result {
            case .success(_):
                completion(nil)
            case .error(let error):
                completion(error)
            }
        }
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func requestPermission() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
            
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            break
        case .denied:
            delegate?.showChangeSettingsAlert()
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            break
        }
        
    }
    
    var isPermissionObtained: Bool {
        let status = CLLocationManager.authorizationStatus()
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.didChangeStatus(isAuthorized: status == .authorizedAlways)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        let latitude = String(format: "%f", lastLocation.coordinate.latitude)
        let longitude = String(format: "%f", lastLocation.coordinate.longitude)
        let location = Location(longitude: longitude, latitude: latitude)
        delegate?.didChangeLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

