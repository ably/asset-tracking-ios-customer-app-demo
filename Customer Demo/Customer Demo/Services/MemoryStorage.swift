//
//  MemoryStorage.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation

class MemoryStorage {
    
    struct Credentials {
        let username: String
        let password: String
    }
    
    static let shared = MemoryStorage()

    var credentials: Credentials?
}
