//
//  UIView.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import UIKit

extension UIView {
    enum Axis: String {
        case vertical = "V"
        case horizontal = "H"
    }

    func fillSuperview(priority: UILayoutPriority = .required, overlapMargins: Bool = true) {
        self.fillSuperview(axis: .vertical, priority: priority, overlapMargins: overlapMargins)
        self.fillSuperview(axis: .horizontal, priority: priority, overlapMargins: overlapMargins)
    }

    func fillSuperview(axis: Axis, priority: UILayoutPriority = .required, overlapMargins: Bool = true) {
        self.translatesAutoresizingMaskIntoConstraints = false

        let visualFormat = overlapMargins ? "|[subview]|" : "|-[subview]-|"
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: axis.rawValue+":"+visualFormat, metrics: nil, views: ["subview": self])

        for constraint in constraints {
            constraint.priority = priority
        }
        self.superview?.addConstraints(constraints)
    }
}
