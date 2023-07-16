//
//  TermsOfUseButton.swift
//  OnBoardingImpl
//
//  Created by jung on 2023/07/07.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import DesignKit

final class TermsOfUseButton: UIView {
	lazy var isChecked: Bool = false {
		didSet {
			if isChecked == true {
				checkButton.tintColor = .green100
			} else {
				checkButton.tintColor = .gray70
			}
		}
	}
	
	let checkButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		let image = UIImage(systemName: "checkmark.circle")
		button.setImage(image, for: .normal)
		button.tintColor = .gray70
		
		return button
	}()
	
	let titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
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
		NSLayoutConstraint.activate([
			checkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
			checkButton.centerYAnchor.constraint(equalTo: centerYAnchor),
			checkButton.widthAnchor.constraint(equalToConstant: 24),
			checkButton.heightAnchor.constraint(equalToConstant: 24),
			checkButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
			checkButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
			
			titleLabel.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 12),
			titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}
}

extension TermsOfUseButton {
	func setTitle(_ title: String) {
		self.titleLabel.text = title
	}
}
