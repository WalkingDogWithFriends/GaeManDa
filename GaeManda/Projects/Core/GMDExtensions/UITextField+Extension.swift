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
}

public extension Reactive where Base: UITextField {
	var cursorChanged: ControlProperty<UITextRange?> {
		return cursor
	}
	
	var cursor: ControlProperty<UITextRange?> {
		return base.rx.controlProperty(
			editingEvents: [.allTouchEvents, .allEditingEvents, .valueChanged],
			getter: { textField in
				textField.selectedTextRange
			},
			setter: { textField, value in
				if textField.selectedTextRange != value {
					textField.selectedTextRange = value
				}
			}
		)
	}
}
