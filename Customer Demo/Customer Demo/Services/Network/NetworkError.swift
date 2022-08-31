//
//  NetworkError.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation

enum NetworkError: Error {
    
    case `internal`(Error)
    case unknown
}
