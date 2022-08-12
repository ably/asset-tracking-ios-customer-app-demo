//
//  LocationUpdateHistoryInteractor.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation
import AblyAssetTrackingSubscriber

class LocationUpdateHistoryInteractor {
    
    private var data: [LocationUpdate] = []
    
    var averageInterval: Double? {
        if data.count < 2 {
            return nil
        }
        let update1 = data[0]
        let update2 = data[data.count-1]
        
        return (update2.location.timestamp - update1.location.timestamp) / Double(data.count - 1)
    }
    
    var lastInterval: Double? {
        if data.count < 2 {
            return nil
        }
        let update1 = data[data.count-2]
        let update2 = data[data.count-1]
        
        return update2.location.timestamp - update1.location.timestamp
    }
    
    func append(_ datum: LocationUpdate) {
        data.append(datum)
        if data.count > 5 {
            data.removeFirst()
        }
    }
}
