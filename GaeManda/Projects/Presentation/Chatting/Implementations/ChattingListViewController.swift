//
//  ChattingListViewController.swift
//  ChattingImpl
//
//  Created by jung on 2023/08/16.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs

protocol ChattingListPresentableListener: AnyObject { }

final class ChattingListViewController:
	UIViewController,
	ChattingListPresentable,
	ChattingListViewControllable {
	weak var listener: ChattingListPresentableListener?
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}
