//
//  DogProfileEditViewController.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs

protocol DogProfileEditPresentableListener: AnyObject { }

final class DogProfileEditViewController:
	UIViewController,
	DogProfileEditPresentable,
	DogProfileEditViewControllable {
	weak var listener: DogProfileEditPresentableListener?
}
