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
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var trackableIDTextField: UITextField!
    @IBOutlet private weak var minimumDisplacementTextField: UITextField!
    @IBOutlet private weak var desiredIntervalTextField: UITextField!
    @IBOutlet private weak var accuracySegmentedControl: UISegmentedControl!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
    let viewModel = SetupViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        startButton.layer.cornerRadius = 16
        
        let segmentedControlBackgroundColor = UIColor(red: 50/255, green: 116/255, blue: 219/255, alpha: 1)
        accuracySegmentedControl.backgroundColor = segmentedControlBackgroundColor
        accuracySegmentedControl.selectedSegmentIndex = 0

        minimumDisplacementTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        desiredIntervalTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        
        minimumDisplacementTextField.delegate = self
        desiredIntervalTextField.delegate = self
        trackableIDTextField.delegate = self
        
        setupKeyboardObserver()
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
        else {
            showValidationError()
            return
        }
        
        let accuracy = viewModel.getSelectedPublisherResolutionAccuracy(accuracyIndex: accuracySegmentedControl.selectedSegmentIndex)
        let resolution = Resolution(accuracy: accuracy, desiredInterval: desiredInterval, minimumDisplacement: minimumDisplacement)
        
        subscriberStatusViewController.configure(resolution: resolution, trackableID: trackableID)

        navigationController?.pushViewController(subscriberStatusViewController, animated: true)
    }
    
    func showValidationError() {
        let alertController = UIAlertController(title: "Validation error", message: "Please fill out all fields", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true)
    }
}

extension SetupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SetupViewController: KeyboardObserver {

    func keyboardWillAppear(properties: KeyboardProperties) {
        self.bottomConstraint.constant = properties.frame.height
        UIView.animate(withKeyboardProperties: properties) {
            self.view.layoutIfNeeded()
        }
    }

    func keyboardWillDisappear(properties: KeyboardProperties) {
        self.bottomConstraint.constant = 0
        UIView.animate(withKeyboardProperties: properties) {
            self.view.layoutIfNeeded()
        }
    }
}
