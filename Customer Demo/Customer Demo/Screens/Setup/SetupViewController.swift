//
//  SetupViewController.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import UIKit
import CoreLocation
import AblyAssetTrackingSubscriber

class SetupViewController: UIViewController {
    @IBOutlet private var startButton: UIButton!
    @IBOutlet private var trackableIDTextField: UITextField!
    @IBOutlet private var minimumDisplacementTextField: UITextField!
    @IBOutlet private var desiredIntervalTextField: UITextField!
    @IBOutlet private var accuracySegmentedControl: UISegmentedControl!
    
    let viewModel = SetupViewModel()

    override func viewDidLoad() {
        startButton.layer.cornerRadius = 16
        
        let segmentedControlBackgroundColor = UIColor(red: 50/255, green: 116/255, blue: 219/255, alpha: 1)
        accuracySegmentedControl.backgroundColor = segmentedControlBackgroundColor
        accuracySegmentedControl.selectedSegmentIndex = 0

        minimumDisplacementTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        desiredIntervalTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        
        minimumDisplacementTextField.delegate = self
        desiredIntervalTextField.delegate = self
        trackableIDTextField.delegate = self

        super.viewDidLoad()
    }

    @IBAction private func startButtonPressed() {
        let storyboard = UIStoryboard(name: "SubscriberStatus", bundle: nil)
        let subscriberStatusViewController = storyboard.instantiateViewController(withIdentifier: "SubscriberStatus")
        guard let subscriberStatusViewController = subscriberStatusViewController as? SubscriberStatusViewController,
              let minimumDisplacementText = minimumDisplacementTextField.text,
              !minimumDisplacementText.isEmpty,
              let minimumDisplacement = Double(minimumDisplacementText),
              let desiredIntervalText = desiredIntervalTextField.text,
              !desiredIntervalText.isEmpty,
              let desiredInterval = Double(desiredIntervalText),
              let trackableID = trackableIDTextField.text,
              !trackableID.isEmpty
        else { return }
        
        let accuracy = viewModel.getSelectedPublisherResolutionAccuracy(accuracyIndex: accuracySegmentedControl.selectedSegmentIndex)
        let resolution = Resolution(accuracy: accuracy, desiredInterval: desiredInterval, minimumDisplacement: minimumDisplacement)
        
        subscriberStatusViewController.configure(resolution: resolution, trackableID: trackableID)

        navigationController?.pushViewController(subscriberStatusViewController, animated: true)
    }
}

extension SetupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
