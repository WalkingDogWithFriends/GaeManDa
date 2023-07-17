//
//  LoggedInViewController.swift
//  Dev-GaeManda
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs

protocol LoggedInPresentableListener: AnyObject { }

final class LoggedInTabBarController:
	UITabBarController,
	LoggedInPresentable,
	LoggedInViewControllable {
	weak var listener: LoggedInPresentableListener?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tabBar.isTranslucent = false
		tabBar.backgroundColor = .white
	}
	
	func setViewControllers(_ viewControllers: [ViewControllable]) {
		super.setViewControllers(
			viewControllers.map { $0.uiviewController },
			animated: false
		)
	}
}
