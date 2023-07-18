//
//  UIViewController+Extensions.swift
//  Extensions
//
//  Created by jung on 2023/07/12.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import GMDUtils

public extension UIViewController {
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		self.view.endEditing(true)
	}
}

public extension UIViewController {
	func hideTabBar() {
		guard let parent = self.parent as? FloatingTabBarPresentable else { return }

		parent.dismissTabBar()
	}
	
	func showTabBar() {
		guard let parent = self.parent as? FloatingTabBarPresentable else { return }
		
		parent.presentTabBar()
	}
}
