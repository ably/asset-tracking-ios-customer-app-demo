//
//  Environment.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation

public enum EnvironmentHelper {
    private static let infoDictionary: [String: Any] = {
        guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dictionary = NSDictionary(contentsOfFile: filePath) as? [String: Any]
        else {
            fatalError("Plist file not found")
        }
        return dictionary
    }()
    
    static let backendURL: String = {
        guard let key = EnvironmentHelper.infoDictionary["BACKEND_URL"] as? String, !key.isEmpty else {
            fatalError("BACKEND_URL not set in plist for this environment")
        }
        return key
    }()
}
