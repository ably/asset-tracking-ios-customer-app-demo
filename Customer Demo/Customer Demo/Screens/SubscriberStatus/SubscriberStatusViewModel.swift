//
//  SubscriberStatusViewModel.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation
import CoreLocation
import AblyAssetTrackingSubscriber

class SubscriberStatusViewModel {
    
    weak var viewController: SubscriberStatusViewController?
    let locationManager = CLLocationManager()

    let trackableID: String
    let subscriberResolution: Resolution
    let aatService = AATService.sharedInstance
    
    enum Mode { case trackableOnly, trackableWithUser, free }
    var mode: Mode = .trackableOnly
    
    init(subscriberResolution: Resolution, trackableID: String, viewController: SubscriberStatusViewController) {
        self.trackableID = trackableID
        self.subscriberResolution = subscriberResolution
        self.viewController = viewController
    }

    func viewDidLoad() {
        locationManager.requestWhenInUseAuthorization()
        aatService.delegate = self
        aatService.startSubscriber(subscriberResolution: subscriberResolution, trackingID: trackableID) { result in
            print("startSubscriber(subscriberResolution:trackingID:completion:) result is \(result)")
        }
    }
    
    func viewWillDisappear() {
        aatService.stopSubscriber()
    }
}

extension SubscriberStatusViewModel: AATServiceDelegate {
    func subscriber(sender: Subscriber, didChangeAssetConnectionStatus status: ConnectionState) {
        viewController?.updateStatus(status)
        print("subscriber(sender: \(sender), didChangeAssetConnectionStatus: \(status))")
    }
    
    func subscriber(sender: Subscriber, didFailWithError error: ErrorInformation) {
        print("subscriber(sender: \(sender), didFailWithError: \(error))")
    }
    
    func subscriber(sender: Subscriber, didUpdateDesiredInterval interval: Double) {
        print("subscriber(sender: \(sender), didUpdateDesiredInterval: \(interval))")
    }
    
    func subscriber(sender: Subscriber, didUpdateEnhancedLocation locationUpdate: LocationUpdate) {
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
