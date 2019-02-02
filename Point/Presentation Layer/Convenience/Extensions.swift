//
//  Extensions.swift
//  Point
//
//  Created by NewUser on 23/09/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

// MARK: - UIImageView
extension UIImageView {
    func rotate360Degrees(duration: CFTimeInterval = 3) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

// MARK: - UIViewController
extension UIViewController {
    func showAlert(title: String = "Error", message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - UIAlertController
extension UIAlertController {
    func addActions(actions: UIAlertAction ...) {
        actions.forEach { addAction($0) }
    }
}

// MARK: - UITextView
extension UITextView {
    
    func setCoursorToTheBeginningOfTheLine() {
        selectedTextRange = textRange(from: beginningOfDocument,
                                               to: beginningOfDocument)
    }
}

// MARK: - UIImage
extension UIImage {
    static func placeholderImage() -> UIImage? {
        return UIImage(named: "Portrait_Placeholder")
    }
}

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
