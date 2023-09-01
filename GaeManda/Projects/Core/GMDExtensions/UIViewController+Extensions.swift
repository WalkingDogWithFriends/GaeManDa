//
//  UIViewController+Extensions.swift
//  Extensions
//
//  Created by jung on 2023/07/12.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

extension UIViewController {
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		self.view.endEditing(true)
	}
}
