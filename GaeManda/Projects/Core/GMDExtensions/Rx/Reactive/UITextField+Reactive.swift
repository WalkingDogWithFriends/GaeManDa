//
//  UITextField+Reactive.swift
//  GMDExtensions
//
//  Created by 김영균 on 9/25/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

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
