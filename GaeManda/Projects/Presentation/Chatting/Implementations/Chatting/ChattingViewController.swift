//
//  ChattingViewController.swift
//  Chatting
//
//  Created by jung on 2023/08/18.
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
	// MARK: - UI Components
	private let tableView = UITableView()
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
}

// MARK: - Setting UI
private extension ChattingViewController {
	func setupUI() {
		setupSubViews()
		setConstraints()
	}
	
	func setupSubViews() { }
	
	func setConstraints() { }
}
