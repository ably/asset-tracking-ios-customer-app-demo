//
//  SignInPresenter.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import UIKit

class SignInPresenter {
    
    weak var viewController: SignInViewController?
    
    func handleSubmitAction(username: String, password: String) {
        let request = Request("\(EnvironmentHelper.backendURL)/deliveryService/mapbox", method: .get)
        viewController?.showActivityIndicator()
        request.authenticate(user: username, password: password).responseJSON { [weak self] response in
            DispatchQueue.main.async {
                self?.viewController?.hideActivityIndicator()
            
                switch response.result {
                case .failure(let error):
                    self?.showError(error)
                case .success:
                    MemoryStorage.shared.credentials = .init(username: username, password: password)
                    self?.authenticated()
                }
            }
        }
    }
}

private extension SignInPresenter {
    
    func authenticated() {
        let storyboard = UIStoryboard(name: "Setup", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as? SetupViewController
        guard let viewController = viewController else {
            fatalError()
        }
                
        self.viewController?.navigationController?.setViewControllers([viewController], animated: true)
    }
    
    func showError(_ error: NetworkError? = nil) {
        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription ?? "Please try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        viewController?.present(alertController, animated: true)
    }
}
