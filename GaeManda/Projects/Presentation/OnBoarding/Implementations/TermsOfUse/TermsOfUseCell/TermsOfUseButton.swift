//
//  TermsOfUseButton.swift
//  OnBoardingImpl
//
//  Created by jung on 2023/07/07.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import GMDUtils

final class TermsOfUseButton: UIView {
	lazy var isChecked: Bool = false {
		didSet {
			if isChecked == true {
				checkButton.tintColor = .init(hexCode: "#65BF4D")
			} else {
				checkButton.tintColor = .init(hexCode: "#ABABAB")
			}
		}
	}
	
	let checkButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		let image = UIImage(systemName: "checkmark.circle")
		button.setImage(image, for: .normal)
		button.tintColor = .init(hexCode: "#ABABAB")
		
		return button
	}()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.tintColor = .black
		label.font = .systemFont(ofSize: 15)
		
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
			checkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
			checkButton.centerYAnchor.constraint(equalTo: centerYAnchor),
			checkButton.widthAnchor.constraint(equalToConstant: 24),
			checkButton.heightAnchor.constraint(equalToConstant: 24),
			checkButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
			checkButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
			
			titleLabel.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 10),
			titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}
}

extension TermsOfUseButton {
	func setTitle(_ title: String) {
		self.titleLabel.text = title
	}
}
