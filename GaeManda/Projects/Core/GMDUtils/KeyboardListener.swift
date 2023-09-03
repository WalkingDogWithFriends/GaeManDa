//
//  KeyboardListener.swift
//  GMDExtensions
//
//  Created by jung on 2023/08/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import GMDExtensions

public protocol KeyboardListener {
	var keyboardShowNotification: NSObjectProtocol? { get set }
	var keyboardHideNotification: NSObjectProtocol? { get set }
	
	func keyboardWillShow(height: CGFloat)
	func keyboardWillHide()
}

public extension KeyboardListener where Self: UIViewController {
	@discardableResult
	func registerKeyboardShowNotification() -> NSObjectProtocol? {
		let showNotification = NotificationCenter.default.addObserver(
			forName: UIResponder.keyboardWillShowNotification,
			object: nil,
			queue: nil
		) { [weak self] notification in
			guard let height = notification.keyboardHeight else { return }
			self?.keyboardWillShow(height: height)
		}
		return showNotification
	}
	
	@discardableResult
	func registerKeyboardHideNotification() -> NSObjectProtocol? {
		let hideNotification = NotificationCenter.default.addObserver(
			forName: UIResponder.keyboardWillHideNotification,
			object: nil,
			queue: nil
		) { [weak self] _ in
			self?.keyboardWillHide()
		}
		return hideNotification
	}
	
	func removeKeyboardNotification(_ notifications: [NSObjectProtocol?]) {
		notifications.forEach(NotificationCenter.default.removeObserver(_:))
	}
}
