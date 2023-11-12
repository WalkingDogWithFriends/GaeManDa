//
//  TermsOfUseCell.swift
//  OnBoardingImpl
//
//  Created by jung on 2023/07/07.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import SnapKit
import DesignKit
import Entity
import GMDUtils

final class TermsOfUseCell: UITableViewCell {
	// MARK: - UI Components
	private let termsOfUseButton = TermsOfUseButton()
	private let subTitleLabel = UILabel()
	
	// MARK: - Initializers
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.selectionStyle = .none
		self.termsOfUseButton.isUserInteractionEnabled = false
		self.setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError()
	}
}

// MARK: - UI Methods
private extension TermsOfUseCell {
	func setupUI() {
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		contentView.addSubviews(termsOfUseButton, subTitleLabel)
	}
	
	func setConstraints() {
		termsOfUseButton.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
			make.height.equalTo(44)
		}
		
		subTitleLabel.snp.makeConstraints { make in
			make.top.equalTo(termsOfUseButton.snp.bottom)
			make.bottom.equalToSuperview()
			make.leading.equalToSuperview().offset(52)
			make.trailing.equalToSuperview()
		}
	}
}

// MARK: - Internal Methods
extension TermsOfUseCell {
	func configuration(_ termsOfUse: TermsOfUse) {
		let prefix = termsOfUse.isRequired ? "[필수]" : "[선택]"
		termsOfUseButton.setTitle("\(prefix) \(termsOfUse.title)")
		subTitleLabel.attributedText = termsOfUse.subTitle?.textmg(color: .gray80)
	}
	
	func toggleButtonChecked() {
		self.termsOfUseButton.isChecked.toggle()
	}
	
	func setButtonChecked(_ isChecked: Bool) {
		self.termsOfUseButton.isChecked = isChecked
	}
}
