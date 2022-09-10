//
//  SetupViewController.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import UIKit
import CoreLocation
import AblyAssetTrackingSubscriber

class SetupViewController: UIViewController, ActivityIndicating {
    @IBOutlet private weak var sourceLatitudeTextField: UITextField!
    @IBOutlet private weak var sourceLongitudeTextField: UITextField!
    @IBOutlet private weak var destinationLatitudeTextField: UITextField!
    @IBOutlet private weak var destinationLongitudeTextField: UITextField!

    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var minimumDisplacementTextField: UITextField!
    @IBOutlet private weak var desiredIntervalTextField: UITextField!
    @IBOutlet private weak var accuracySegmentedControl: UISegmentedControl!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
    let presenter = SetupPresenter()

    override func viewDidLoad() {
        presenter.viewController = self
        
        super.viewDidLoad()

        startButton.layer.cornerRadius = 16
        
        let segmentedControlBackgroundColor = UIColor(red: 50/255, green: 116/255, blue: 219/255, alpha: 1)
        accuracySegmentedControl.backgroundColor = segmentedControlBackgroundColor
        accuracySegmentedControl.selectedSegmentIndex = 0

        minimumDisplacementTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        desiredIntervalTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        
        minimumDisplacementTextField.delegate = self
        desiredIntervalTextField.delegate = self
        
        setupKeyboardObserver()
    }

    @IBAction private func startButtonPressed() {
        presenter.handleSubmitAction(
            sourceLocationText: (sourceLatitudeTextField.text ?? "", sourceLongitudeTextField.text ?? ""),
            destinationLocationText: (destinationLatitudeTextField.text ?? "", destinationLongitudeTextField.text ?? ""),
            minimumDisplacementText: minimumDisplacementTextField.text ?? "",
            desiredIntervalText: desiredIntervalTextField.text ?? "",
            accuracyIndex: accuracySegmentedControl.selectedSegmentIndex
        )
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
