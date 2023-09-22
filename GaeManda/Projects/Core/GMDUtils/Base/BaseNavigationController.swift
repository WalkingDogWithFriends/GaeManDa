//
//  BaseNavigationController.swift
//  GMDUtils
//
//  Created by jung on 9/22/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

public protocol SwipeRecognigerDelegate: UIViewController {
	func swipeRecognigerDismiss()
}

public final class BaseNavigationController: UINavigationController {
	public override func viewDidLoad() {
		super.viewDidLoad()
		interactivePopGestureRecognizer?.delegate = self
	}
}

// MARK: - UIGestureRecognizerDelegate
extension BaseNavigationController: UIGestureRecognizerDelegate {
	public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		if 
			viewControllers.count > 1,
			let topViewController = topViewController as? SwipeRecognigerDelegate {
			topViewController.swipeRecognigerDismiss()
		}
		
		return false
	}
}
