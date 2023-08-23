//
//  Notification+Extension.swift
//  GMDExtensions
//
//  Created by jung on 2023/08/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

public extension Notification {
	var keyboardFrame: CGRect? {
		guard let userInfo = self.userInfo,
					let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
		else {
			return nil
		}
		return keyboardFrame
	}
	
	var keyboardHeight: CGFloat? {
		return keyboardFrame?.height
	}
}
