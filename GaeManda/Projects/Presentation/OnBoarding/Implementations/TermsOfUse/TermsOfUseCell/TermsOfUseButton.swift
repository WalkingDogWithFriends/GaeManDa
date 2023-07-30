//
//  TermsOfUseButton.swift
//  OnBoardingImpl
//
//  Created by jung on 2023/07/07.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import SnapKit
import DesignKit

final class TermsOfUseButton: UIView {
	lazy var isChecked: Bool = false {
		didSet {
			checkButton.tintColor = isChecked ? .green100 : .gray70
		}
	}
	
	let checkButton: UIButton = {
		let button = UIButton()
		let image = UIImage(systemName: "checkmark.circle")
		button.setImage(image, for: .normal)
		button.tintColor = .gray70
		
		return button
	}()
	
	let titleLabel: UILabel = {
		let label = UILabel()
		label.tintColor = .black
		label.font = .r16
		
		return label
	}()
	
	init() {
		super.init(frame: .zero)
		setupUI()
	}
	
	convenience init(title: String) {
		self.init()
		setTitle(title)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupUI()
	}
	
	private func setupUI() {
		layer.cornerRadius = 4
		setupSubviews()
		setConstraints()
	}
	
	private func setupSubviews() {
		addSubview(checkButton)
		addSubview(titleLabel)
	}
			
	private func setConstraints() {
		checkButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(12)
			make.width.height.equalTo(24)
			make.top.equalToSuperview().offset(8)
			make.bottom.equalToSuperview().offset(-8)
		}
		
		titleLabel.snp.makeConstraints { make in
			make.leading.equalTo(checkButton.snp.trailing).offset(12)
			make.centerY.equalToSuperview()
		}
	}
}

extension TermsOfUseButton {
	func setTitle(_ title: String) {
		self.titleLabel.text = title
	}
}
