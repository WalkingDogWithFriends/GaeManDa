//
//  TermsOfUseCell.swift
//  OnBoardingImpl
//
//  Created by jung on 2023/07/07.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
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
		
		return button
	}()
	
	lazy var subTitleLabel: UILabel = {
		let label = UILabel()
		label.textColor = .gray80
		label.font = .r12
		
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
		var prefix = termsOfUse.isRequired ? "[필수]" : "[선택]"
		
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
		termsOfUseButton.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
		}
		
		subTitleLabel.snp.makeConstraints { make in
			make.top.equalTo(termsOfUseButton.snp.bottom)
			make.bottom.equalToSuperview()
			make.leading.equalTo(termsOfUseButton.snp.leading)
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
	}
	
	func configuration(_ termsOfUse: TermsOfUse) {
		setupUI(termsOfUse: termsOfUse)
	}
}
