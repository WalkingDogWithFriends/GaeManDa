//
//  UITextField+Extension.swift
//  Extensions
//
//  Created by jung on 2023/07/09.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

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
	
	// suffix위치에 커서가 가지 않도록 해주는 함수입니다.
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
		
		guard
			cursorEndPosition > suffixStartIndex,
			let newPosition = self.position(from: endOfDocument, offset: -2),
			let newStartPosition = self.position(from: selectedRange.start, offset: 0)
		else { return }
		
		// 단일 커서일 때
		if selectedRange.start == selectedRange.end {
			setSelectedTextRange(from: newPosition, to: newPosition)
		// 드래그한 커서일 때
		} else {
			setSelectedTextRange(from: newStartPosition, to: newPosition)
		}
	}
}

// MARK: - Private Extension
private extension UITextField {
	/// 원하는 위치로 textField의 커서를 조정합니다.
	func setSelectedTextRange(
		from startPosition: UITextPosition,
		to endPosition: UITextPosition) {
		DispatchQueue.main.async {
			self.selectedTextRange = self.textRange(
				from: startPosition,
				to: endPosition
			)
		}
	}
}

// MARK: - Reactive Extension
public extension Reactive where Base: UITextField {
	var isEditing: ControlProperty<Bool> {
		return base.rx.controlProperty(
			editingEvents: [],
			getter: { textField in
				textField.isEditing
			},
			setter: { textField, value in
				textField.endEditing(value)
			}
		)
	}
}
