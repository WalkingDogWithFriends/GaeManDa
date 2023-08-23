//
//  ReceiveCell.swift
//  ChattingImpl
//
//  Created by jung on 2023/08/21.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import SnapKit
import DesignKit
import Entity
import GMDExtensions

final class ReceiveCell: UITableViewCell {
	// MARK: - UI Components
	private let messageLabel: UITextView = {
		let textView = UITextView()
		textView.backgroundColor = .gray40
		textView.clipsToBounds = true
		textView.layer.cornerRadius = 16
		textView.isScrollEnabled = false
		textView.isEditable = false
		textView.textContainerInset = .init(top: 12, left: 8, bottom: 12, right: 8)
		textView.font = .r12
		
		return textView
	}()
	
	// MARK: - Initializers
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Configure
	func configure(with message: Message) {
		messageLabel.text = message.message
	}
}

// MARK: - UI Setting
private extension ReceiveCell {
	func setupUI() {
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		contentView.addSubview(messageLabel)
	}
	
	func setConstraints() {
		messageLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(10)
			make.bottom.equalToSuperview().offset(-10)
			make.leading.equalToSuperview().offset(89)
			make.width.lessThanOrEqualTo(220)
		}
	}
}
