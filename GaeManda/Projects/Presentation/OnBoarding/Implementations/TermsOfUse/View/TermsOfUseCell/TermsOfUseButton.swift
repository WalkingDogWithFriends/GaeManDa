//
//  TermsOfUseButton.swift
//  OnBoardingImpl
//
//  Created by jung on 2023/07/07.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture
import SnapKit
import DesignKit

final class TermsOfUseButton: UIView {
	// MARK: - Properties
	var isChecked: Bool {
		didSet {
			checkButton.imageView?.image = isChecked ? .iconCheckGreen : .iconCheckGray
		}
	}
	
	// MARK: - UI Components
	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.spacing = 12
		stackView.alignment = .leading
		
		return stackView
	}()
	
	private let checkButton: UIButton = {
		let button = UIButton()
		let image = UIImage.iconCheckGray
		button.setImage(image, for: .normal)
		button.tintColor = .gray70
		button.isUserInteractionEnabled = false
		
		return button
	}()
	
	private	let titleLabel = UILabel()
	
	// MARK: - Initializers
	init(title: String = "") {
		self.isChecked = false
		super.init(frame: .zero)
		setTitle(title)
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - UI Methods
private extension TermsOfUseButton {
	func setupUI() {
		layer.cornerRadius = 4
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		addSubview(stackView)
		stackView.addArrangedSubviews(checkButton, titleLabel)
	}
	
	func setConstraints() {
		stackView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(8)
			make.bottom.equalToSuperview().offset(-8)
			make.leading.equalToSuperview().offset(12)
			make.trailing.equalToSuperview().offset(-12)
		}
		
		checkButton.snp.makeConstraints { make in
			make.width.equalTo(checkButton.snp.height)
			make.centerY.equalToSuperview()
		}
		
		titleLabel.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
		}
	}
}

// MARK: - Internal Methods
extension TermsOfUseButton {
	func setTitle(_ title: String) {
		self.titleLabel.attributedText = title.attributedString(
			font: .r16,
			color: .black,
			lineSpacing: -0.5
		)
	}
}
