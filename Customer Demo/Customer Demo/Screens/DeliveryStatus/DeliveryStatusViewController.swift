//
//  DeliveryStatusViewController.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation
import UIKit
import AblyAssetTrackingSubscriber
import MapKit

class DeliveryStatusViewController: UIViewController {
    
    @IBOutlet private var orderIDLabel: UILabel!
    @IBOutlet private var mapView: MKMapView!
    
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var datetimeLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var updateIntervalLabel: UILabel!
    @IBOutlet private var skippedLocationsLabel: UILabel!
    @IBOutlet private var mapTrackingModeButton: UIButton!
    @IBOutlet private var mapTypeButton: UIButton!
    
    weak var riderAnnotation: MKPointAnnotation?
    var viewModel: DeliveryStatusViewModel?
    var ignoreRegionChange = true
    
    func configure(resolution: Resolution, orderID: String, jsonWebToken: String) {
        viewModel = DeliveryStatusViewModel(resolution: resolution, orderID: orderID, jsonWebToken: jsonWebToken)
        title = "Status"
    }
    
    override func viewDidLoad() {
        viewModel?.viewController = self
        
        orderIDLabel.text = "Order ID: \(viewModel?.orderID ?? "Unknown")"
        updateMapTrackingModeButton()
        updateMapTypeButton()
        statusLabel.text = "Status: Unknown"
        mapView.delegate = self

        viewModel?.viewDidLoad()
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParent {
            viewModel?.viewWillDisappear()
        }
        
        super.viewWillDisappear(animated)
    }
    
    func updateLocation(locationUpdate: LocationUpdate) {
        guard let viewModel = viewModel else {
            return
        }
        
        let location = CLLocationCoordinate2D(
            latitude: locationUpdate.location.coordinate.latitude,
            longitude: locationUpdate.location.coordinate.longitude
        )
        
        if let annotation = riderAnnotation {
            annotation.coordinate = location
        } else {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            mapView.addAnnotation(annotation)
            
            riderAnnotation = annotation
        }
        
        updateMapRegion()
        
        datetimeLabel.text = "Time: \(Date(timeIntervalSince1970: locationUpdate.location.timestamp).description)"
        locationLabel.text = "Location: \(String(format: "%.6f", location.latitude)), \(String(format: "%.6f", location.longitude)) " +
            "(± \(String(format: "%.1f", locationUpdate.location.horizontalAccuracy)) m) " +
            "heading \(String(format: "%.1f", locationUpdate.location.course))° " +
            String(format: "%.2f", locationUpdate.location.speed) + " m/s " +
            String(format: "%.2f", locationUpdate.location.altitude) + " MASL"
                
        var lastUpdateIntervalString = "Unknown"
        if let value = viewModel.locationUpdateHistoryInteractor.lastInterval {
            lastUpdateIntervalString = String(format: "%.4f", value)
        }
        var averageUpdateIntervalString = "Unknown"
        if let value = viewModel.locationUpdateHistoryInteractor.averageInterval {
            averageUpdateIntervalString = String(format: "%.4f", value)
        }
        let desiredUpdateIntervalString = String(format: "%.4f", viewModel.resolution.desiredInterval)
        
        updateIntervalLabel.text = "Update interval: \(lastUpdateIntervalString) / \(averageUpdateIntervalString) / \(desiredUpdateIntervalString) (last / avg / desired)"
        
        skippedLocationsLabel.text = "Skipped locations: \(locationUpdate.skippedLocations.count)"
    }
    
    func updateStatus(_ status: ConnectionState) {
        let statusDescription: String
        
        switch status {
        case .failed:
            statusDescription = "Failed"
        case .offline:
            statusDescription = "Offline"
        case .online:
            statusDescription = "Online"
        }
        
        statusLabel.text = "Status: \(statusDescription)"
    }
    
    @IBAction private func mapTrackingModeButtonTapped() {
        guard let mode = viewModel?.mapTrackingMode else { return }
        
        switch mode {
        case .rider:
            viewModel?.mapTrackingMode = .riderAndCustomer
        case .riderAndCustomer:
            viewModel?.mapTrackingMode = .rider
        case .free:
            viewModel?.mapTrackingMode = .rider
        }
        
        updateMapTrackingModeButton()
        updateMapRegion()
    }
    
    @IBAction private func mapTypeButtonTapped() {
        switch mapView.mapType {
        case .standard:
            mapView.mapType = .hybrid
        default:
            mapView.mapType = .standard
        }

        updateMapTypeButton()
    }
    
    func updateMapRegion() {
        guard let mode = viewModel?.mapTrackingMode else { return }
        
        switch mode {
        case .rider:
            guard let location = riderAnnotation?.coordinate else { return }
            
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan())
            ignoreRegionChange = true
            mapView.setRegion(region, animated: true)
        case .riderAndCustomer:
            ignoreRegionChange = true
            mapView.showAnnotations(mapView.annotations, animated: true)
        case .free:
            () // do nothing
        }
    }
    
    func updateMapTrackingModeButton() {
        guard let mode = viewModel?.mapTrackingMode else { return }
        
        let image: UIImage?
        switch mode {
        case .rider:
            image = UIImage(systemName: "person.fill")
        case .riderAndCustomer:
            image = UIImage(systemName: "person.2.fill")
        case .free:
            image = UIImage(systemName: "hand.wave.fill")
        }
        
        mapTrackingModeButton.setTitle("", for: .normal)
        mapTrackingModeButton.setImage(image, for: .normal)
    }
    
    func updateMapTypeButton() {
        mapTypeButton.setTitle("", for: .normal)
        
        let image: UIImage?
        switch mapView.mapType {
        case .hybrid:
            image = UIImage(systemName: "airplane")
        default:
            image = UIImage(systemName: "map.fill")
        }
        
        mapTypeButton.setImage(image, for: .normal)
    }
    
    func showError(_ error: ErrorInformation? = nil) {
        let alertController = UIAlertController(title: "Error", message: error?.message ?? "Please try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
}

extension DeliveryStatusViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !ignoreRegionChange {
            viewModel?.mapTrackingMode = .free
            updateMapTrackingModeButton()
        }
        ignoreRegionChange = false
    }
}
