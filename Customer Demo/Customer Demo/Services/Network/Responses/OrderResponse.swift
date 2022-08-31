//
//  OrderResponse.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation

struct OrderResponse: Decodable {
    
    struct AblyToken: Decodable {
        let token: String
    }
    
    let orderID: Int
    let ably: AblyToken
    
    enum CodingKeys: String, CodingKey {
        case orderID = "orderId"
        case ably
    }
}
