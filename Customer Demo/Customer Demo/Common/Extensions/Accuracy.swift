//
//  Accuracy.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation
import AblyAssetTrackingCore

extension Accuracy {
    
    init?(index: Int) {
        switch index {
        case 0:
            self = Accuracy.minimum
        case 1:
            self = Accuracy.low
        case 2:
            self = Accuracy.balanced
        case 3:
            self = Accuracy.high
        case 4:
            self = Accuracy.maximum
        default:
            return nil
        }
    }
}
