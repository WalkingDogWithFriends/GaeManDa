//
//  DogProfileEditViewController.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs
import GMDUtils

protocol DogProfileEditPresentableListener: AnyObject {
	func backbuttonDidTap()
}

final class DogProfileEditViewController:
	UIViewController,
	DogProfileEditPresentable,
	DogProfileEditViewControllable {
	weak var listener: DogProfileEditPresentableListener?
	
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
private extension DogProfileEditViewController {
	@objc func backbuttonDidTap() {
		listener?.backbuttonDidTap()
	}
}
