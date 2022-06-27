//
//  SetupViewModel.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation
import CoreLocation
import AblyAssetTrackingSubscriber

class SetupViewModel: NSObject {
    
    func getSelectedPublisherResolutionAccuracy(accuracyIndex: Int) -> Accuracy {
        switch accuracyIndex {
        case 0:
            return Accuracy.minimum
        case 1:
            return Accuracy.low
        case 2:
            return Accuracy.balanced
        case 3:
            return Accuracy.high
        case 4:
            return Accuracy.maximum
        default:
            return Accuracy.low
        }
    }
}
