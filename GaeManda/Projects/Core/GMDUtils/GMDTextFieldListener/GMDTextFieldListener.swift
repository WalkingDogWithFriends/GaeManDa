//
//  TextFieldListener.swift
//  GMDUtils
//
//  Created by jung on 2023/09/06.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import DesignKit

public protocol GMDTextFieldListener {
	var textDidChangeNotification: NSObjectProtocol? { get set }
	
	func textDidChange(_ textField: GMDTextField)
}

public extension GMDTextFieldListener where Self: UIViewController {
	@discardableResult
	func registerTextFieldNotification() -> NSObjectProtocol? {
		let textDidChangeNotification = NotificationCenter.default.addObserver(
			forName: UITextField.textDidChangeNotification,
			object: nil,
			queue: nil
		) { [weak self] notification in
			guard
				let textField = notification.object as? UnderLineTextField,
				let gmdTextField = textField.superview?.superview as? GMDTextField
			else { return }
			
			self?.textDidChange(gmdTextField)
		}
		return textDidChangeNotification
	}
	
	func removeTextFieldNotification(_ notifications: [NSObjectProtocol?]) {
		notifications.forEach(NotificationCenter.default.removeObserver(_:))
	}
	
	func textDidChange(_ textField: GMDTextField) {
		textField.titleLabel.alpha = textField.text.isEmpty ? 0.0 : 1.0
		
		if !textField.text.isEmpty {
			textField.mode = .normal
		}
	}
}
