//
//  DeliveryStatusViewModel.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation
import CoreLocation
import AblyAssetTrackingSubscriber

class DeliveryStatusViewModel {
    
    weak var viewController: DeliveryStatusViewController?
    let locationManager = CLLocationManager()

    let orderID: String
    let jsonWebToken: String
    let resolution: Resolution
    let aatService = AATService.sharedInstance
    
    enum MapTrackingMode { case rider, riderAndCustomer, free }
    var mapTrackingMode: MapTrackingMode = .rider
    
    var locationUpdateHistoryInteractor = LocationUpdateHistoryInteractor()
    
    init(resolution: Resolution, orderID: String, jsonWebToken: String) {
        self.resolution = resolution
        self.orderID = orderID
        self.jsonWebToken = jsonWebToken
    }

    func viewDidLoad() {
        locationManager.requestWhenInUseAuthorization()
        aatService.delegate = self
        
        guard let username = MemoryStorage.shared.credentials?.username else {
            self.viewController?.showError()
            return
        }
        
        aatService.startSubscriber(
            trackingID: orderID,
            clientID: username,
            jsonWebToken: jsonWebToken,
            subscriberResolution: resolution
        ) { [weak self] result in
            print("startSubscriber(subscriberResolution:trackingID:completion:) result is \(result)")
            if case let .failure(error) = result {
                self?.viewController?.showError(error)
            }
        }
    }
    
    func viewWillDisappear() {
        aatService.stopSubscriber()
    }
}

extension DeliveryStatusViewModel: AATServiceDelegate {
    func subscriber(sender: Subscriber, didChangeAssetConnectionStatus status: ConnectionState) {
        viewController?.updateStatus(status)
        print("subscriber(sender: \(sender), didChangeAssetConnectionStatus: \(status))")
    }
    
    func subscriber(sender: Subscriber, didFailWithError error: ErrorInformation) {
        print("subscriber(sender: \(sender), didFailWithError: \(error))")
        viewController?.showError(error)
    }
    
    func subscriber(sender: Subscriber, didUpdateDesiredInterval interval: Double) {
        print("subscriber(sender: \(sender), didUpdateDesiredInterval: \(interval))")
    }
    
    func subscriber(sender: Subscriber, didUpdateEnhancedLocation locationUpdate: LocationUpdate) {
        locationUpdateHistoryInteractor.append(locationUpdate)
        viewController?.updateLocation(locationUpdate: locationUpdate)
        print("subscriber(sender: \(sender), didUpdateEnhancedLocation: \(locationUpdate))")
    }
    
    func subscriber(sender: Subscriber, didUpdateRawLocation locationUpdate: LocationUpdate) {
        print("subscriber(sender: \(sender), didUpdateRawLocation: \(locationUpdate))")
    }
    
    func subscriber(sender: Subscriber, didUpdateResolution resolution: Resolution) {
        print("subscriber(sender: \(sender), didUpdateResolution: \(resolution))")
    }
}
