//
//  Request.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation

class Request {
    
    var urlRequest: URLRequest
    
    init(_ url: URL, method: Method) {
        let request = URLRequest(url: url)
        urlRequest = request
        
        urlRequest.httpMethod = method.rawValue
    }
    
    convenience init(_ urlString: String, method: Method) {
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        self.init(url, method: method)
    }
    
    func set(parameters: [String: Any]) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            return
        }
        
        urlRequest.setValue("\(String(describing: jsonData.count))", forHTTPHeaderField: "Content-Length")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
    }
    
    @discardableResult
    func authenticate(user: String, password: String) -> Self {
        let credentialsData = "\(user):\(password)".data(using: .utf8)
        guard let credentialsString = credentialsData?.base64EncodedString() else {
            return self
        }

        urlRequest.setValue("Basic \(credentialsString)", forHTTPHeaderField: "Authorization")
        return self
    }
    
    func responseJSON(_ completion: @escaping (Response<Any>) -> Void) {
        self.responseData { dataResponse in
            let response = Response<Any>()
            response.urlResponse = dataResponse.urlResponse
            
            switch dataResponse.result {
            case .failure(let error):
                response.result = .failure(error)
            case .success(let data):
                if let jsonObject = try? JSONSerialization.jsonObject(with: data) {
                    response.result = .success(jsonObject)
                } else {
                    response.result = .failure(.unknown)
                }
            }
            
            completion(response)
        }
    }
    
    func responseDecodable<T: Decodable>(of type: T.Type, _ completion: @escaping (Response<T>) -> Void) {
        self.responseData { dataResponse in
            let response = Response<T>()
            response.urlResponse = dataResponse.urlResponse
            
            switch dataResponse.result {
            case .failure(let error):
                response.result = .failure(error)
            case .success(let data):
                if let object = try? JSONDecoder().decode(type, from: data) {
                    response.result = .success(object)
                } else {
                    response.result = .failure(.unknown)
                }
            }
            
            completion(response)
        }
    }
    
    func responseData(_ completion: @escaping (Response<Data>) -> Void) {
        let task = URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            let response = Response<Data>()
            response.urlResponse = urlResponse
            
            if let data = data {
                response.result = .success(data)
            } else {
                if let error = error {
                    response.result = .failure(.`internal`(error))
                } else {
                    response.result = .failure(.unknown)
                }
            }
            
            completion(response)
        }
        task.resume()
    }
}
