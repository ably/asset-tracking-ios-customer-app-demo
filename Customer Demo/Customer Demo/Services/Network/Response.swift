//
//  Response.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation

class Response<T> {
    
    var urlResponse: URLResponse?
    var result: Result<T, NetworkError>
    
    init() {
        result = .failure(.unknown)
    }
}
