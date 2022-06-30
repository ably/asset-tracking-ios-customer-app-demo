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
    var ignoreRegionChange = true
    
    func configure(resolution: Resolution, trackableID: String) {
        viewModel = SubscriberStatusViewModel(subscriberResolution: resolution, trackableID: trackableID, viewController: self)
        title = "Status"
    }
    
    override func viewDidLoad() {
        trackableIDLabel.text = "Trackable ID: \(viewModel?.trackableID ?? "Unknown")"
        updateModeButton()
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
        case .trackableOnly:
            viewModel?.mode = .trackableWithUser
        case .trackableWithUser:
            viewModel?.mode = .trackableOnly
        case .free:
            viewModel?.mode = .trackableOnly
        }
        
        updateModeButton()
        updateMapRegion()
    }
    
    func updateMapRegion() {
        guard let mode = viewModel?.mode else { return }
        
        switch mode {
        case .trackableOnly:
            guard let location = trackableAnnotation?.coordinate else { return }
            
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan())
            ignoreRegionChange = true
            mapView.setRegion(region, animated: true)
        case .trackableWithUser:
            ignoreRegionChange = true
            mapView.showAnnotations(mapView.annotations, animated: true)
        case .free:
            () // do nothing
        }
    }
    
    func updateModeButton() {
        guard let mode = viewModel?.mode else { return }
        
        let image: UIImage?
        switch mode {
        case .trackableOnly:
            image = UIImage(systemName: "person.2.fill")
        case .trackableWithUser:
            image = UIImage(systemName: "person.fill")
        case .free:
            image = UIImage(systemName: "hand.wave.fill")
        }
        
        modeButton.setTitle("", for: .normal)
        modeButton.setImage(image, for: .normal)
    }
}

extension SubscriberStatusViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !ignoreRegionChange {
            viewModel?.mode = .free
            updateModeButton()
        }
        ignoreRegionChange = false
    }
}
