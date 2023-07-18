//
//  ChattingViewController.swift
//  ChattingImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs
import DesignKit

protocol ChattingPresentableListener: AnyObject { }

final class ChattingViewController:
	UIViewController,
	ChattingPresentable,
	ChattingViewControllable {
	weak var listener: ChattingPresentableListener?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		print("Chatting ViewDidLoad")
	}
	
	private func setupUI() {
		view.backgroundColor = .gray
		
		setupSubviews()
		setConstraints()
		bind()
	}
		
	private func setupSubviews() { }
	
	private func setConstraints() { }
	
	private func bind() { }
}
