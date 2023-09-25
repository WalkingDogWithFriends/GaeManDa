//
//  UITextField+Extension.swift
//  Extensions
//
//  Created by jung on 2023/07/09.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

public extension UITextField {
	func setLeftImage(
		_ image: UIImage?,
		size: Int,
		rightPadding: Int = 10,
		leftPadding: Int = 0
	) {
		let paddingViewWidth = leftPadding + rightPadding + size
		let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: paddingViewWidth, height: size))
		let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: size, height: size))
		imageView.image = image
		imageView.tintColor = .black
		leftPaddingView.addSubview(imageView)
		leftView = leftPaddingView
		leftViewMode = .always
	}
	
	func setRightView<T: UIView>(
		_ view: T,
		size: CGFloat,
		padding: CGFloat
	) {
		let paddingViewWith = size + padding
		let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: paddingViewWith, height: size))
		view.frame = CGRect(x: 0, y: 0, width: size, height: size)
		paddingView.addSubview(view)
		self.rightView = paddingView
	}
	
	func setPlaceholdColor(_ color: UIColor) {
		guard let placeholder = self.placeholder else { return }

		self.attributedPlaceholder = NSAttributedString(
			string: placeholder,
			attributes: [.foregroundColor: color]
		)
	}
	
	func moveCusorLeftTo(suffix: String) {
		guard
			let text = self.text,
			let selectedRange = self.selectedTextRange,
			let suffixRange = text.range(of: suffix)
		else {
			return
		}
		
		let suffixStartIndex = text.distance(
			from: text.startIndex,
			to: suffixRange.lowerBound
		)
		
		let cursorEndPosition = self.offset(
			from: self.beginningOfDocument,
			to: selectedRange.end
		)
		
		if
			cursorEndPosition > suffixStartIndex,
			let newPosition = self.position(from: selectedRange.end, offset: -2) {
			self.selectedTextRange = self.textRange(
				from: newPosition,
				to: newPosition
			)
		}
	}
}
