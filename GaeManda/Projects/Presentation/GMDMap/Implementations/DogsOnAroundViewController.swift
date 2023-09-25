//
//  DogsOnAroundViewController.swift
//  DogsOnAroundImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs

protocol DogsOnAroundPresentableListener: AnyObject { }

final class DogsOnAroundViewController:
	UIViewController,
	DogsOnAroundPresentable,
	DogsOnAroundViewControllable {
	weak var listener: DogsOnAroundPresentableListener?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .green
		print("DogsOnAround ViewDidLoad")
	}
}
