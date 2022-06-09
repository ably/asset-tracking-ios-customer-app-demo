//
//  AATService.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation
import AblyAssetTrackingSubscriber
import CoreLocation.CLLocation
import UIKit

protocol AATServiceDelegate: AnyObject {
    func subscriber(sender: Subscriber, didUpdateResolution resolution: Resolution)
    func subscriber(sender: Subscriber, didFailWithError error: ErrorInformation)
    func subscriber(sender: Subscriber, didUpdateRawLocation locationUpdate: LocationUpdate)
    func subscriber(sender: Subscriber, didUpdateDesiredInterval interval: Double)
    func subscriber(sender: Subscriber, didUpdateEnhancedLocation locationUpdate: LocationUpdate)
    func subscriber(sender: Subscriber, didChangeAssetConnectionStatus status: ConnectionState)
}

class AATService {
    static let sharedInstance = AATService()
    
    let ablyAPIKey = EnvironmentHelper.ablyKey

    var delegate: AATServiceDelegate?
    
    private(set) var desiredResolution: Resolution?
    private var subscriber: Subscriber?

    func startSubscriber(subscriberResolution: Resolution, trackingID: String, completion: @escaping ResultHandler<Void>) {
        desiredResolution = subscriberResolution
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown device"
        
        // TODO: We'll be using token auth instead
        subscriber = SubscriberFactory.subscribers()
            .connection(ConnectionConfiguration(apiKey: ablyAPIKey, clientId: deviceID))
            .trackingId(trackingID)
            .delegate(self)
            .log(LogConfiguration())
            .resolution(subscriberResolution)
            .start(completion: completion)
    }

    func stopSubscriber(_ completion: ResultHandler<Void>? = nil) {
        subscriber?.stop(completion: {[weak self] result in
            switch result {
            case .success:
                self?.subscriber = nil
            default:
                break
            }
            completion?(result)
        })
    }
}

extension AATService: SubscriberDelegate {
    func subscriber(sender: Subscriber, didUpdateResolution resolution: Resolution) {
        delegate?.subscriber(sender: sender, didUpdateResolution: resolution)
    }
    
    func subscriber(sender: Subscriber, didFailWithError error: ErrorInformation) {
        delegate?.subscriber(sender: sender, didFailWithError: error)
    }
    
    func subscriber(sender: Subscriber, didUpdateRawLocation locationUpdate: LocationUpdate) {
        delegate?.subscriber(sender: sender, didUpdateRawLocation: locationUpdate)
    }
    
    func subscriber(sender: Subscriber, didUpdateDesiredInterval interval: Double) {
        delegate?.subscriber(sender: sender, didUpdateDesiredInterval: interval)
    }
    
    func subscriber(sender: Subscriber, didUpdateEnhancedLocation locationUpdate: LocationUpdate) {
        delegate?.subscriber(sender: sender, didUpdateEnhancedLocation: locationUpdate)
    }
    
    func subscriber(sender: Subscriber, didChangeAssetConnectionStatus status: ConnectionState) {
        delegate?.subscriber(sender: sender, didChangeAssetConnectionStatus: status)
    }
}
