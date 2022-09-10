//
//  ActivityIndicating.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import UIKit

protocol ActivityIndicating {
    func showActivityIndicator()
    func hideActivityIndicator()
    func showActivityIndicator(animated: Bool)
    func hideActivityIndicator(animated: Bool)
}

extension ActivityIndicating where Self: UIViewController {
    func showActivityIndicator() {
        self.showActivityIndicator(animated: true)
    }

    func hideActivityIndicator() {
        self.hideActivityIndicator(animated: true)
    }

    func showActivityIndicator(animated: Bool) {
        let view = ActivityIndicatorView()
        view.show(in: self.view, animated: animated)
    }

    func hideActivityIndicator(animated: Bool) {
        ActivityIndicatorView.hide(from: self.view, animated: animated)
    }
}
