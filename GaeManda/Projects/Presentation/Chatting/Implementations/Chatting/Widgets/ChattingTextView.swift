//
//  ChattingTextView.swift
//  Chatting
//
//  Created by jung on 2023/08/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import DesignKit

final class ChattingTextView: UIView {
	// MARK: - UI Components
	fileprivate let cameraButton: UIButton = {
		let button = UIButton()
		button.setImage(
			.iconCameraOn,
			for: .normal
		)
		button.tintColor = .gray70
		
		return button
	}()
	
	fileprivate let textField: UITextField = {
		let textField = UITextField()
		textField.backgroundColor = .gray40
		textField.layer.borderColor = UIColor.gray50.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 15
		
		return textField
	}()
	
	fileprivate let sendButton: UIButton = {
		let button = UIButton()
		button.setImage(
			.iconSendGreen,
			for: .normal
		)
		button.tintColor = .green100
		button.isHidden = true
		
		return button
	}()
	
	// MARK: - Property
	var buttonIsHidden: Bool = true {
		didSet {
			sendButton.isHidden = buttonIsHidden
		}
	}
	
	// MARK: - Initializer
	init() {
		super.init(frame: .zero)
		
		backgroundColor = .gray20
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
}

// MARK: - UI Setting
private extension ChattingTextView {
	func setupUI() {
		setupSubviews()
		setConstraints()
		
		/// set padding for textField left
		let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
		textField.leftView = paddingView
		textField.leftViewMode = .always
		
		textField.setRightView(sendButton, size: 24, padding: 12)
		textField.rightViewMode = .always
	}
	
	func setupSubviews() {
		addSubviews(cameraButton, textField)
	}
	
	func setConstraints() {
		cameraButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(8)
			make.width.height.equalTo(20)
			make.centerY.equalTo(textField)
		}
		
		textField.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(8)
			make.leading.equalTo(cameraButton.snp.trailing).offset(12)
			make.bottom.equalToSuperview().offset(-8)
			make.trailing.equalToSuperview().offset(-12)
			make.height.equalTo(40)
		}
	}
}

// MARK: - Reactive Extension
extension Reactive where Base: ChattingTextView {
	var sendButtonDidTapped: ControlEvent<Void> {
		base.sendButton.rx.tap
	}
	
	var cameraButtonDidTapped: ControlEvent<Void> {
		base.cameraButton.rx.tap
	}
	
	var text: ControlProperty<String?> {
		base.textField.rx.text
	}
}
