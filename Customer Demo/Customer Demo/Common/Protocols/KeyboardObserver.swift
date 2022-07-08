//
//  KeyboardObserver.swift
//  Customer Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import UIKit

struct KeyboardProperties {
    let frame: CGRect
    let duration: TimeInterval
    let options: UIView.AnimationOptions

    init?(userInfo: [AnyHashable: Any], for viewController: UIViewController) {
        guard let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return nil
        }
        self.frame = frame.cgRectValue
        
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return nil
        }
        self.duration = TimeInterval(duration.doubleValue)
        
        guard let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber else {
            return nil
        }
        
        self.options = UIView.AnimationOptions(rawValue: ((UInt(animationCurve.intValue << 16))))
    }
}

protocol KeyboardObserver {

    func setupKeyboardObserver()
    
    func keyboardWillAppear(properties: KeyboardProperties)
    func keyboardWillDisappear(properties: KeyboardProperties)
}

extension KeyboardObserver where Self: UIViewController {

    func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil
        ) { [weak self] (notification) in
            guard let self = self,
                  let userInfo = notification.userInfo,
                  let keyboard = KeyboardProperties(userInfo: userInfo, for: self) else {
                return
            }
            
            self.keyboardWillAppear(properties: keyboard)
        }

        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil
        ) { [weak self] (notification) in
            guard let self = self,
                  let userInfo = notification.userInfo,
                  let keyboard = KeyboardProperties(userInfo: userInfo, for: self) else {
                return
            }

            self.keyboardWillDisappear(properties: keyboard)
        }
    }
}

extension UIView {

    static func animate(withKeyboardProperties properties: KeyboardProperties, animations: @escaping (() -> Void)) {
        self.animate(
            withDuration: properties.duration,
            delay: 0.0,
            options: [.beginFromCurrentState, properties.options],
            animations: animations,
            completion: nil
        )
    }
}
