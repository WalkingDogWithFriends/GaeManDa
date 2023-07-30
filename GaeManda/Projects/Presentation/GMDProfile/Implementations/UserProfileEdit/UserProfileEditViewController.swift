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

protocol UserProfileEditPresentableListener: AnyObject { }

final class UserProfileEditViewController:
	UIViewController,
	UserProfileEditPresentable,
	UserProfileEditViewControllable {
	weak var listener: UserProfileEditPresentableListener?
}
