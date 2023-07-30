//
//  UserProfileEditViewController.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs
import GMDUtils

protocol UserProfileEditPresentableListener: AnyObject {
	func backbuttonDidTap()
}

final class UserProfileEditViewController:
	UIViewController,
	UserProfileEditPresentable,
	UserProfileEditViewControllable {
	weak var listener: UserProfileEditPresentableListener?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		setupBackNavigationButton(
			target: self,
			action: #selector(backbuttonDidTap)
		)
	}
}

// MARK: Action
private extension UserProfileEditViewController {
	@objc func backbuttonDidTap() {
		listener?.backbuttonDidTap()
	}
}
