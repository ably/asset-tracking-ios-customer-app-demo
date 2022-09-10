//
//  ActivityIndicatorView.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import UIKit

class ActivityIndicatorView: UIView {
    lazy private var backgroundView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        view.alpha = 0.2

        view.widthAnchor.constraint(equalToConstant: 90).isActive = true
        view.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        return view
    }()

    lazy private var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        
        loader.color = .white
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.startAnimating()

        return loader
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.onInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.onInit()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    func onInit() {
        self.backgroundColor = UIColor.clear

        self.addSubview(self.backgroundView)
        self.backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        self.addSubview(self.loader)
        self.loader.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.loader.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}

extension ActivityIndicatorView {
    func show(in superview: UIView, animated: Bool = true) {
        self.alpha = 0
        superview.addSubview(self)
        self.fillSuperview()
        UIView.animate(withDuration: animated ? 0.2 : 0) {
            self.alpha = 1
        }
    }

    static func hide(from superview: UIView, animated: Bool = true) {
        for subview in superview.subviews {
            guard let subview = subview as? ActivityIndicatorView else {
                continue
            }

            UIView.animate(
                withDuration: animated ? 0.2 : 0,
                animations: {
                    subview.alpha = 0
                },
                completion: { _ in
                    subview.removeFromSuperview()
                }
            )
        }
    }
}
