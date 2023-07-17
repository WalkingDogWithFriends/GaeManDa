//
//  ChattingViewController.swift
//  ChattingImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs

protocol ChattingPresentableListener: AnyObject { }

final class ChattingViewController:
	UIViewController,
	ChattingPresentable,
	ChattingViewControllable {
	weak var listener: ChattingPresentableListener?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .blue
		print("Chatting ViewDidLoad")
	}
}
