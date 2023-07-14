//
//  KeyboardRespondViewController.swift
//  Utils
//
//  Created by jung on 2023/07/09.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

open class KeyboardRespondViewController: UIViewController {
	public var editingView: UIView?
	public var paddingValue: CGFloat = 0
	
	override open func viewDidLoad() {
		super.viewDidLoad()		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillShow),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillHidden),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}
}

public extension KeyboardRespondViewController {
	@objc func keyboardWillShow(_ notification: NSNotification) {
		guard let editingView = editingView else { return	}
		
		let viewBottom = editingView.convert(editingView.bounds, to: self.view).maxY

		moveUpViewWithKeyboard(
			notification: notification,
			viewBottom: viewBottom
		)
	}
	
	@objc func keyboardWillHidden(_ notification: NSNotification) {
		moveDownViewWithKeyboard()
	}
	
	func moveUpViewWithKeyboard(
		notification: NSNotification,
		viewBottom: CGFloat
	) {
		guard
			let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
		else {
			return
		}
		let topOfKeyBoard = self.view.frame.height - keyboardSize.height
		let moveValue = viewBottom + paddingValue - topOfKeyBoard
		
		if moveValue > 0 {
			self.view.frame.origin.y = -moveValue
		}
	}
	
	func moveDownViewWithKeyboard() {
		self.view.frame.origin.y = 0
	}
}
