//
//  File.swift
//  CorePresentation
//
//  Created by jung on 12/15/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import CorePresentation
import DesignKit

final class UserNameTextField: UIView {
	// MARK: - Properties
	var mode: NicknameTextFieldMode = .default {
		didSet {
			switch mode {
				case .default: setDefaultMode()
				case .valid: setValidMode()
				case .duplicate: setDuplicateMode()
				case .notEntered: setNotEnteredMode()
			}
		}
	}
	
	var text: String {
		get {
			textField.text ?? ""
		}
		set {
			textField.text = newValue
		}
	}
	
	var attributedText: NSAttributedString {
		get {
			textField.attributedText ?? NSAttributedString(string: "")
		}
		set {
			textField.attributedText = newValue
		}
	}
	
	var titleAlpha: CGFloat {
		get {
			titleLabel.alpha
		}
		set {
			titleLabel.alpha = newValue
		}
	}
	
	var textFieldPadding: UIEdgeInsets {
		get {
			textField.padding
		}
		set {
			textField.padding = newValue
		}
	}
	
	// MARK: - UI Components
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.textColor = .gray90
		label.numberOfLines = 1
		label.font = .r12
		label.alpha = 0
		
		return label
	}()
	
	public let textField: UnderLineTextField = {
		let textField = UnderLineTextField()
		textField.font = .r15
		textField.underLineColor = .gray90
		textField.setPlaceholdColor(.gray90)
		
		return textField
	}()
	
	private let subTitleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 1
		label.font = .r12
		label.layer.opacity = 0.0
		
		return label
	}()
	
	// MARK: - Initializers
	public init(title: String) {
		super.init(frame: .zero)
		
		titleLabel.text = title
		textField.placeholder = title
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError()
	}
}

// MARK: - UI Setting
private extension UserNameTextField {
	func setupUI() {
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		addSubviews(titleLabel, textField, subTitleLabel)
	}
	
	func setConstraints() {
		titleLabel.snp.makeConstraints { make in
			make.leading.top.equalToSuperview()
		}
		
		textField.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(titleLabel.snp.bottom).offset(8)
		}
		
		subTitleLabel.snp.makeConstraints { make in
			make.leading.bottom.equalToSuperview()
			make.top.equalTo(textField.snp.bottom).offset(2)
		}
	}
}

// MARK: - UI Logic
private extension UserNameTextField {
	func setDefaultMode() {
		subTitleLabel.layer.opacity = 0.0
	}
	
	func setValidMode() {
		subTitleLabel.textColor = .green100
		subTitleLabel.text = "사용 가능한 닉네임입니다."
		subTitleLabel.layer.opacity = 1.0
	}
	
	func setDuplicateMode() {
		subTitleLabel.textColor = .red100
		subTitleLabel.text = "이미 존재하는 닉네임입니다."
		subTitleLabel.layer.opacity = 1.0
	}
	
	func setNotEnteredMode() {
		subTitleLabel.textColor = .red100
		subTitleLabel.text = "닉네임을 입력해주세요"
		subTitleLabel.layer.opacity = 1.0
	}
}

// MARK: - Internal Methods
extension UserNameTextField {
	func setRightView(_ rightView: UIView, viewMode: UITextField.ViewMode = .always) {
		textField.rightView = rightView
		textField.rightViewMode = viewMode
	}
}

// MARK: - Reactive Extension
extension Reactive where Base: UserNameTextField {
	var text: ControlProperty<String?> {
		base.textField.rx.text
	}
	
	var attributedText: ControlProperty<NSAttributedString?> {
		base.textField.rx.attributedText
	}
}
