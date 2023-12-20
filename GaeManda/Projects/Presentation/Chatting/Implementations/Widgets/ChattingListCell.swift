//
//  ChattingListCell.swift
//  ChattingImpl
//
//  Created by jung on 2023/08/16.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import SnapKit
import DesignKit
import GMDExtensions

final class ChattingListCell: UITableViewCell {
	// MARK: UI Components
	private let profileImageView = RoundImageView()
	
	private let nickNameLabel: UILabel = {
		let label = UILabel()
		label.font = .b16
		label.textColor = .black
		
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
		label.textColor = .black
		label.numberOfLines = 1
		
		return label
	}()
	
	private let newMessageCountLabel: UILabel = {
		let label = UILabel()
		label.font = .r8
		label.textColor = .white
		label.backgroundColor = .green100
		label.textAlignment = .center
		label.layer.cornerRadius = 8
		label.clipsToBounds = true
		label.isHidden = true
		
		return label
	}()
	
	// MARK: - Initializers
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.selectionStyle = .none
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		profileImageView.cancel()
	}
	
	func configure(with viewModel: ChattingListDataSource.ViewModel) {
		profileImageView.loadImage(urlString: viewModel.profileImage)
		nickNameLabel.text = viewModel.nickName
		dateLabel.text = viewModel.recentMessageDate
		messageLabel.text = viewModel.message
		if let newMessageCount = viewModel.newMessageCount {
			newMessageCountLabel.isHidden = false
			newMessageCountLabel.text = "\(newMessageCount)"
		}
	}
}

// MARK: UI Setting
private extension ChattingListCell {
	enum Constant {
		static let contentViewInsets = UIEdgeInsets(top: 12, left: 32, bottom: 12, right: 32)
		static let profileImageSize = CGSize(width: 60, height: 60)
		static let profileImageOutsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
		static let nickNameLabelBottomPadding: CGFloat = 20
		static let newMessageLabelSize = CGSize(width: 16, height: 16)
	}
	
	func setupUI() {
		setupSubviews()
		setConstraints()
	}
	
	func setupSubviews() {
		contentView.addSubviews(profileImageView, nickNameLabel, dateLabel, messageLabel, newMessageCountLabel)
	}
	
	func setConstraints() {
		profileImageView.snp.makeConstraints { make in
			make.size.equalTo(Constant.profileImageSize)
			make.leading.equalToSuperview().offset(Constant.contentViewInsets.left)
			make.top.equalToSuperview().offset(Constant.contentViewInsets.top)
			make.bottom.equalToSuperview().offset(-Constant.contentViewInsets.bottom)
		}
		
		nickNameLabel.snp.makeConstraints { make in
			make.leading.equalTo(profileImageView.snp.trailing).offset(Constant.profileImageOutsets.right)
			make.top.equalTo(profileImageView.snp.top)
		}
		
		dateLabel.snp.makeConstraints { make in
			make.trailing.equalToSuperview().offset(-Constant.contentViewInsets.right)
			make.centerY.equalTo(nickNameLabel.snp.centerY)
		}
		
		messageLabel.snp.makeConstraints { make in
			make.leading.equalTo(profileImageView.snp.trailing).offset(Constant.profileImageOutsets.right)
			make.bottom.equalTo(profileImageView.snp.bottom)
		}
		
		newMessageCountLabel.snp.makeConstraints { make in
			make.width.greaterThanOrEqualTo(Constant.newMessageLabelSize.width)
			make.height.equalTo(Constant.newMessageLabelSize.height)
			make.centerY.equalTo(messageLabel.snp.centerY)
			make.trailing.equalToSuperview().offset(-Constant.contentViewInsets.right)
			make.leading.equalTo(messageLabel.snp.trailing).offset(8)
		}
		
		profileImageView.setContentHuggingPriority(.init(755), for: .horizontal)
		newMessageCountLabel.setContentHuggingPriority(.init(755), for: .horizontal)
		
		profileImageView.setContentHuggingPriority(.init(755), for: .horizontal)
		newMessageCountLabel.setContentCompressionResistancePriority(.init(755), for: .horizontal)
	}
}
