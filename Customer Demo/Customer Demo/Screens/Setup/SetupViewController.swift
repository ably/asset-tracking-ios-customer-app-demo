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
    @IBOutlet private weak var orderIDTextField: UITextField!
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
        orderIDTextField.delegate = self
        
        setupKeyboardObserver()
    }

    @IBAction private func startButtonPressed() {
        let storyboard = UIStoryboard(name: "DeliveryStatus", bundle: nil)
        let deliveryStatusViewController = storyboard.instantiateViewController(withIdentifier: "DeliveryStatus")
        guard let deliveryStatusViewController = deliveryStatusViewController as? DeliveryStatusViewController,
              let minimumDisplacementText = minimumDisplacementTextField.text,
              !minimumDisplacementText.isEmpty,
              let minimumDisplacement = Double(minimumDisplacementText),
              let desiredIntervalText = desiredIntervalTextField.text,
              !desiredIntervalText.isEmpty,
              let desiredInterval = Double(desiredIntervalText),
              let orderID = orderIDTextField.text,
              !orderID.isEmpty
        else {
            showValidationError()
            return
        }
        
        let accuracy = viewModel.getSelectedPublisherResolutionAccuracy(accuracyIndex: accuracySegmentedControl.selectedSegmentIndex)
        let resolution = Resolution(accuracy: accuracy, desiredInterval: desiredInterval, minimumDisplacement: minimumDisplacement)
        
        deliveryStatusViewController.configure(resolution: resolution, orderID: orderID)

        navigationController?.pushViewController(deliveryStatusViewController, animated: true)
    }
    
    func showValidationError() {
        let alertController = UIAlertController(title: "Validation error", message: "Please fill out all fields", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
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
        bottomConstraint.constant = properties.frame.height
        UIView.animate(withKeyboardProperties: properties) {
            self.view.layoutIfNeeded()
        }
    }

    func keyboardWillDisappear(properties: KeyboardProperties) {
        bottomConstraint.constant = 0
        UIView.animate(withKeyboardProperties: properties) {
            self.view.layoutIfNeeded()
        }
    }
}
