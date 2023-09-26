//
//  GMDMapViewController.swift
//  GMDMapImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs

protocol GMDMapPresentableListener: AnyObject { }

final class GMDMapViewController:
	UIViewController,
	GMDMapPresentable,
	GMDMapViewControllable {
	weak var listener: GMDMapPresentableListener?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .green
		print("GMDMap ViewDidLoad")
	}
}
