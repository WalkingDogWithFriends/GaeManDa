//
//  OptionsButton.swift
//  Chatting
//
//  Created by jung on 2023/08/21.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import GMDExtensions

final class ChattingOptionsButton: UIView {
	// MARK: - UI Components
	fileprivate let offAlarmButton: UIButton = {
		let button = UIButton()
		button.setTitle("알림 끄기", for: .normal)
		button.titleLabel?.font = .r16
		button.backgroundColor = .clear
		button.setTitleColor(.black, for: .normal)
		
		return button
	}()
	
	fileprivate let leaveChattingButton: UIButton = {
		let button = UIButton()
		button.setTitle("채팅창 나가기", for: .normal)
		button.titleLabel?.font = .r16
		button.backgroundColor = .clear
		button.setTitleColor(.red100, for: .normal)

		return button
	}()
	
	private let seperatorView: UIView = {
		let view = UIView()
		view.backgroundColor = .gray70
		
		return view
	}()
	
	// MARK: - Initializers
	init() {
		super.init(frame: .zero)
		setupUI()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError()
	}
}

// MARK: - UI Setting
private extension ChattingOptionsButton {
	func setupUI() {
		backgroundColor = .gray20
		layer.cornerRadius = 13
		setupSubviews()
		setConstraints()
	}
	
	func setupSubviews() {
		addSubviews(offAlarmButton, seperatorView, leaveChattingButton)
	}
	func setConstraints() {
		offAlarmButton.snp.makeConstraints { make in
			make.top.leading.equalToSuperview()
			make.width.equalTo(280)
			make.height.equalTo(60)
		}
		
		leaveChattingButton.snp.makeConstraints { make in
			make.top.equalTo(seperatorView.snp.bottom)
			make.bottom.leading.equalToSuperview()
			make.width.equalTo(280)
			make.height.equalTo(60)
		}
		
		seperatorView.snp.makeConstraints { make in
			make.top.equalTo(offAlarmButton.snp.bottom)
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(1)
		}
	}
}

// MARK: - Reactive Extension
extension Reactive where Base: ChattingOptionsButton {
	var offAlarmButtonDidTapped: ControlEvent<Void> {
		base.offAlarmButton.rx.tap
	}
	
	var leaveChattingButtonDidTapped: ControlEvent<Void> {
		base.leaveChattingButton.rx.tap
	}
}
