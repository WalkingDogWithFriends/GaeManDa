//
//  NewDogProfileViewController.swift
//  GMDProfile
//
//  Created by jung on 2023/09/05.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs

protocol NewDogProfilePresentableListener: AnyObject { }

final class NewDogProfileViewController:
	UIViewController,
	NewDogProfilePresentable,
	NewDogProfileViewControllable {
	weak var listener: NewDogProfilePresentableListener?
}
