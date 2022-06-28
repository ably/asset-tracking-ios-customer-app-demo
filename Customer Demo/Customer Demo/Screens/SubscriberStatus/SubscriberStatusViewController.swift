//
//  SubscriberStatusViewController.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation
import UIKit
import AblyAssetTrackingSubscriber
import MapKit

class SubscriberStatusViewController: UIViewController {
    
    @IBOutlet private var trackableIDLabel: UILabel!
    @IBOutlet private var mapView: MKMapView!
    
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var datetimeLabel: UILabel!
    @IBOutlet private var latitudeLabel: UILabel!
    @IBOutlet private var longitudeLabel: UILabel!
    @IBOutlet private var modeButton: UIButton!
    
    weak var trackableAnnotation: MKPointAnnotation?
    var viewModel: SubscriberStatusViewModel?
    
    func configure(resolution: Resolution, trackableID: String) {
        viewModel = SubscriberStatusViewModel(subscriberResolution: resolution, trackableID: trackableID, viewController: self)
        title = "Status"
    }
    
    override func viewDidLoad() {
        trackableIDLabel.text = "Trackable ID: \(viewModel?.trackableID ?? "Unknown")"
        updateModeButton()
        statusLabel.text = "Status: Unknown"
        
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
        let location = CLLocationCoordinate2D(
            latitude: locationUpdate.location.coordinate.latitude,
            longitude: locationUpdate.location.coordinate.longitude
        )
        
        if let annotation = trackableAnnotation {
            annotation.coordinate = location
        } else {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            mapView.addAnnotation(annotation)
            
            trackableAnnotation = annotation
        }
        
        updateMapRegion()
        
        datetimeLabel.text = "Time: \(Date(timeIntervalSince1970: locationUpdate.location.timestamp).description)"
        latitudeLabel.text = "Latitude: \(location.latitude.description)"
        longitudeLabel.text = "Longitude: \(location.longitude.description)"
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
    
    @IBAction private func modeButtonTapped() {
        guard let mode = viewModel?.mode else { return }
        
        switch mode {
        case .noUser:
            viewModel?.mode = .withUser
        case .withUser:
            viewModel?.mode = .noUser
        }
        
        updateModeButton()
        updateMapRegion()
    }
    
    func updateMapRegion() {
        guard let mode = viewModel?.mode else { return }
        
        switch mode {
        case .noUser:
            guard let location = trackableAnnotation?.coordinate else { return }
            
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan())
            mapView.setRegion(region, animated: true)
        case .withUser:
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    func updateModeButton() {
        guard let mode = viewModel?.mode else { return }
        
        let image: UIImage?
        switch mode {
        case .noUser:
            image = UIImage(systemName: "person.2.fill")
        case .withUser:
            image = UIImage(systemName: "person.fill")
        }
        
        modeButton.setTitle("", for: .normal)
        modeButton.setImage(image, for: .normal)
    }
}
