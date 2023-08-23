//
//  KeyboardListener.swift
//  GMDExtensions
//
//  Created by jung on 2023/08/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

public protocol KeyboardListener {
	func keyboardWillShow(height: CGFloat)
	func keyboardWillHide()
}

public extension KeyboardListener where Self: UIViewController {
	func registerKeyboardNotification() {
		NotificationCenter.default.addObserver(
			forName: UIResponder.keyboardWillShowNotification,
			object: nil,
			queue: nil
		) { [weak self] notification in
			guard let height = notification.keyboardHeight else { return }
			self?.keyboardWillShow(height: height)
		}
		
		NotificationCenter.default.addObserver(
			forName: UIResponder.keyboardWillHideNotification,
			object: nil,
			queue: nil
		) { [weak self] _ in
			self?.keyboardWillHide()
		}
	}
	
	func removeKeyboardNotification() {
		NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
		NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
	}
}
