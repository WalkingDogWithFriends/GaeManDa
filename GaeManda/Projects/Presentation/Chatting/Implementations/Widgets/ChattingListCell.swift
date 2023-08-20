//
//  ChattingListCell.swift
//  ChattingImpl
//
//  Created by jung on 2023/08/16.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import GMDExtensions

final class ChattingListCell: UITableViewCell {
	let disposeBag = DisposeBag()
	
	// MARK: UI Components
	private let profileImageView: RoundImageView = {
		let imageView = RoundImageView()
		imageView.backgroundColor = .gray40
		
		return imageView
	}()
	
	private let nickNameLabel: UILabel = {
		let label = UILabel()
		label.font = .b16
		
		return label
	}()
	
	private let dateLabel: UILabel = {
		let label = UILabel()
		label.font = .r12
		label.textColor = .gray90
		
		return label
	}()
	
	private let messageLabel: UILabel = {
		let label = UILabel()
		label.font = .r12
		label.numberOfLines = 1
		
		return label
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.selectionStyle = .none
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
	}
	
	func configure() {
		nickNameLabel.text = "윈터"
		dateLabel.text = "1달 전"
		messageLabel.text = "안녕하세요, 카리나님! 오늘 초코랑 같이 산책하실래요?"
	}
}

// MARK: UI Setting
private extension ChattingListCell {
	func setupUI() {
		setupSubviews()
		setConstraints()
	}
	
	func setupSubviews() {
		contentView.addSubview(profileImageView)
		contentView.addSubview(nickNameLabel)
		contentView.addSubview(dateLabel)
		contentView.addSubview(messageLabel)
	}
	
	func setConstraints() {
		profileImageView.snp.makeConstraints { make in
			make.width.height.equalTo(60)
			make.leading.equalToSuperview().offset(32)
			make.bottom.equalTo(messageLabel.snp.bottom)
		}
		
		nickNameLabel.snp.makeConstraints { make in
			make.leading.equalTo(profileImageView.snp.trailing).offset(20)
			make.top.equalToSuperview().offset(28)
		}
		
		dateLabel.snp.makeConstraints { make in
			make.leading.equalTo(nickNameLabel.snp.trailing).offset(12)
			make.centerY.equalTo(nickNameLabel.snp.centerY)
		}
		
		messageLabel.snp.makeConstraints { make in
			make.leading.equalTo(profileImageView.snp.trailing).offset(20)
			make.top.equalTo(nickNameLabel.snp.bottom).offset(20)
			make.bottom.equalToSuperview().offset(-16)
			make.trailing.equalToSuperview().offset(-32)
		}
	}
}
