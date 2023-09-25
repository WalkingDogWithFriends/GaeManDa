//
//  ViewControllable+Extension.swift
//  GMDExtensions
//
//  Created by 김영균 on 9/25/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs

public extension ViewControllable {
	func present(
		_ viewControllable: ViewControllable,
		animated: Bool,
		completion: (() -> Void)? = nil
	) {
		self.uiviewController.present(
			viewControllable.uiviewController,
			animated: animated,
			completion: completion
		)
	}
	
	func present(
		_ viewControllable: ViewControllable,
		animated: Bool,
		modalPresentationStyle: UIModalPresentationStyle,
		completion: (() -> Void)? = nil
	) {
		viewControllable.uiviewController.modalPresentationStyle = modalPresentationStyle
		self.uiviewController.present(
			viewControllable.uiviewController,
			animated: animated,
			completion: completion
		)
	}
	
	func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
		self.uiviewController.dismiss(animated: animated, completion: completion)
	}
	
	func pushViewController(_ viewControllable: ViewControllable, animated: Bool) {
		if let nav = self.uiviewController as? UINavigationController {
			nav.pushViewController(viewControllable.uiviewController, animated: animated)
		} else {
			self.uiviewController
				.navigationController?
				.pushViewController(viewControllable.uiviewController, animated: animated)
		}
	}
	
	func popViewController(animated: Bool) {
		if let nav = self.uiviewController as? UINavigationController {
			nav.popViewController(animated: animated)
		} else {
			self.uiviewController.navigationController?.popViewController(animated: animated)
		}
	}
	
	func popToRoot(animated: Bool) {
		if let nav = self.uiviewController as? UINavigationController {
			nav.popToRootViewController(animated: animated)
		} else {
			self.uiviewController.navigationController?.popToRootViewController(animated: animated)
		}
	}
	
	func setViewControllers(_ viewControllerables: [ViewControllable]) {
		if let nav = self.uiviewController as? UINavigationController {
			nav.setViewControllers(viewControllerables.map(\.uiviewController), animated: true)
		} else {
			self.uiviewController
				.navigationController?
				.setViewControllers(
					viewControllerables.map(\.uiviewController),
					animated: true
				)
		}
	}
	
	var topViewControllable: ViewControllable {
		var top: ViewControllable = self
		
		while let presented = top.uiviewController.presentedViewController as? ViewControllable {
			top = presented
		}
		
		return top
	}
}
