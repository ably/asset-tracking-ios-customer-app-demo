//
//  SetupPresenter.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import UIKit
import CoreLocation
import AblyAssetTrackingSubscriber

class SetupPresenter: NSObject {
    
    weak var viewController: SetupViewController?
    
    func handleSubmitAction(
        sourceLocationText: (String, String),
        destinationLocationText: (String, String),
        minimumDisplacementText: String,
        desiredIntervalText: String,
        accuracyIndex: Int
    ) {
        if !validate(
            sourceLocationText: sourceLocationText,
            destinationLocationText: destinationLocationText,
            minimumDisplacementText: minimumDisplacementText,
            desiredIntervalText: desiredIntervalText,
            accuracyIndex: accuracyIndex
        ) {
            return
        }
        
        let sourceLocation = CLLocation(
            latitude: Double(sourceLocationText.0) ?? 0,
            longitude: Double(sourceLocationText.1) ?? 0
        )
        let destinationLocation = CLLocation(
            latitude: Double(destinationLocationText.0) ?? 0,
            longitude: Double(destinationLocationText.1) ?? 0
        )
        
        createOrder(source: sourceLocation, destination: destinationLocation) { [weak self] response in
            let storyboard = UIStoryboard(name: "DeliveryStatus", bundle: nil)
            let deliveryStatusViewController = storyboard.instantiateInitialViewController() as? DeliveryStatusViewController
            guard let deliveryStatusViewController = deliveryStatusViewController else {
                fatalError()
            }
            
            let accuracy = Accuracy(index: accuracyIndex) ?? .low
            let minimumDisplacement = Double(minimumDisplacementText) ?? 0
            let desiredInterval = Double(desiredIntervalText) ?? 0
            
            let resolution = Resolution(
                accuracy: accuracy,
                desiredInterval: desiredInterval,
                minimumDisplacement: minimumDisplacement
            )
            
            deliveryStatusViewController.configure(
                resolution: resolution,
                orderID: "\(response.orderID)",
                jsonWebToken: response.ably.token
            )

            self?.viewController?.navigationController?.pushViewController(deliveryStatusViewController, animated: true)
        }
    }
}

private extension SetupPresenter {
    
    func createOrder(source: CLLocation, destination: CLLocation, _ completion: @escaping (OrderResponse) -> Void) {
        let request = Request("\(EnvironmentHelper.backendURL)/deliveryService/orders", method: .post)
        
        guard let credentials = MemoryStorage.shared.credentials else {
            showError()
            return
        }
        
        request.authenticate(user: credentials.username, password: credentials.password)
        request.set(parameters: [
            "from": ["latitude": source.coordinate.latitude, "longitude": source.coordinate.longitude],
            "to": ["latitude": destination.coordinate.latitude, "longitude": destination.coordinate.longitude]
        ])
        
        viewController?.showActivityIndicator()
        request.responseDecodable(of: OrderResponse.self) { [weak self] response in
            DispatchQueue.main.async {
                self?.viewController?.hideActivityIndicator()
                
                switch response.result {
                case .failure(let error):
                    self?.showError(error)
                case .success(let orderResponse):
                    completion(orderResponse)
                }
            }
        }
    }
    
    func validate(
        sourceLocationText: (String, String),
        destinationLocationText: (String, String),
        minimumDisplacementText: String,
        desiredIntervalText: String,
        accuracyIndex: Int
    ) -> Bool {
        guard !sourceLocationText.0.isEmpty,
              Double(sourceLocationText.0) != nil,
              !sourceLocationText.1.isEmpty,
              Double(sourceLocationText.1) != nil,
              !destinationLocationText.0.isEmpty,
              Double(destinationLocationText.0) != nil,
              !destinationLocationText.1.isEmpty,
              Double(destinationLocationText.1) != nil,
              !minimumDisplacementText.isEmpty,
              Double(minimumDisplacementText) != nil,
              !desiredIntervalText.isEmpty,
              Double(desiredIntervalText) != nil,
              Accuracy(index: accuracyIndex) != nil
        else {
            let alertController = UIAlertController(title: "Validation error", message: "Please fill out all fields", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            viewController?.present(alertController, animated: true)

            return false
        }
        
        return true
    }
    
    func showError(_ error: NetworkError? = nil) {
        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription ?? "Please try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        viewController?.present(alertController, animated: true)
    }
}
