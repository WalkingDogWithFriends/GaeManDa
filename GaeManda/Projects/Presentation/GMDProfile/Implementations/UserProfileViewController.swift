//
//  UserProfileViewController.swift
//  ProfileImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs
import DesignKit

protocol UserProfilePresentableListener: AnyObject { }

final class UserProfileViewController:
	UIViewController,
	UserProfilePresentable,
	UserProfileViewControllable {
	weak var listener: UserProfilePresentableListener?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .red
	}
}
