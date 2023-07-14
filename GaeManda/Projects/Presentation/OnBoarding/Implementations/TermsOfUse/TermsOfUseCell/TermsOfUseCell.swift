//
//  TermsOfUseCell.swift
//  OnBoardingImpl
//
//  Created by jung on 2023/07/07.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Entity
import GMDUtils

final class TermsOfUseCell: UITableViewCell {
	static let identifier = "TermsOfUseCell"
	var disposeBag = DisposeBag()
	
	lazy var checkBoxButtonTap: Observable<Void> = {
		return termsOfUseButton.checkButton.rx.tap.asObservable()
	}()
	
	let termsOfUseButton: TermsOfUseButton = {
		let button = TermsOfUseButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		
		return button
	}()
	
	lazy var subTitleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .init(hexCode: "#B8B8B8")
		label.font = .systemFont(ofSize: 13)
		
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.selectionStyle = .none
	}
	
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	private func setupUI(termsOfUse: TermsOfUse) {
		var prefix: String = ""
		
		if termsOfUse.isRequired {
			prefix = "[필수]"
		} else {
			prefix = "[선택]"
		}
		
		termsOfUseButton.setTitle("\(prefix) \(termsOfUse.title)")
		subTitleLabel.text = termsOfUse.subTitle
		
		setupSubviews()
		setConstraints()
	}
	
	private func setupSubviews() {
		contentView.addSubview(termsOfUseButton)
		contentView.addSubview(subTitleLabel)
	}
	
	private func setConstraints() {
		NSLayoutConstraint.activate([
			termsOfUseButton.topAnchor.constraint(equalTo: contentView.topAnchor),
			termsOfUseButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			termsOfUseButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			
			subTitleLabel.topAnchor.constraint(equalTo: termsOfUseButton.bottomAnchor),
			subTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 45),
			subTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
	}
	
	func configuration(_ termsOfUse: TermsOfUse) {
		setupUI(termsOfUse: termsOfUse)
	}
}
