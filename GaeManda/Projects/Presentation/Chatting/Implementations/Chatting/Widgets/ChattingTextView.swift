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
			UIImage(systemName: "camera"),
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
			UIImage(systemName: "arrow.up.circle.fill"),
			for: .normal
		)
		button.tintColor = .green100
		button.isHidden = true
		
		return button
	}()
	
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
		
		textField.rightView = sendButton
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
			make.top.equalToSuperview().offset(10)
			make.leading.equalTo(cameraButton.snp.trailing).offset(12)
			make.bottom.equalTo(safeAreaLayoutGuide)
			make.trailing.equalToSuperview().offset(-12)
		}
	}
}
