//
//  SignInViewController.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation
import UIKit
import Network

class SignInViewController: UIViewController, ActivityIndicating {
    
    @IBOutlet private var usernameTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var submitButton: UIButton!
    
    let presenter = SignInPresenter()
    
    override func viewDidLoad() {
        presenter.viewController = self
        
        super.viewDidLoad()
        
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    @objc func submitButtonTapped() {
        presenter.handleSubmitAction(
            username: usernameTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
    }
}
