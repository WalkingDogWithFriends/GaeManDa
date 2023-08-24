//
//  FloatingTabBarType.swift
//  GMDUtils
//
//  Created by jung on 2023/07/18.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

public protocol FloatingTabBarPresentable {
	func presentTabBar()
	func dismissTabBar()
}

public extension UIViewController {
	func hideTabBar() {
		guard let parent = navigationController?.parent as? FloatingTabBarPresentable else { return }

		parent.dismissTabBar()
	}
	
	func showTabBar() {
		guard let parent = navigationController?.parent as? FloatingTabBarPresentable else { return }
		
		parent.presentTabBar()
	}
}
