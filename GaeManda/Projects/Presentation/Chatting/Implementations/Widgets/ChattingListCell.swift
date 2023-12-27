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
	
	private let alarmOffImageView = UIImageView(image: .iconBellOff)
	
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
		alarmOffImageView.isHidden = viewModel.isAlarmOn
	}
}

// MARK: UI Setting
private extension ChattingListCell {
	enum Constant {
		static let contentViewInsets = UIEdgeInsets(top: 12, left: 32, bottom: 12, right: 32)
		static let profileImageSize = CGSize(width: 60, height: 60)
		static let profileImageOutsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
		static let nickNameLabelBottomPadding: CGFloat = 20
		static let alarmOffImageViewLeadingPadding: CGFloat = 10
		static let alarmOffImageViewSize = CGSize(width: 12, height: 14)
		static let newMessageLabelSize = CGSize(width: 16, height: 16)
	}
	
	func setupUI() {
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		contentView.addSubviews(
			profileImageView, nickNameLabel, alarmOffImageView, dateLabel, messageLabel, newMessageCountLabel
		)
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
			make.top.equalTo(profileImageView)
		}
		
		alarmOffImageView.snp.makeConstraints { make in
			make.centerY.equalTo(nickNameLabel)
			make.leading.equalTo(nickNameLabel.snp.trailing).offset(Constant.alarmOffImageViewLeadingPadding)
			make.size.equalTo(Constant.alarmOffImageViewSize)
		}
		
		dateLabel.snp.makeConstraints { make in
			make.trailing.equalToSuperview().offset(-Constant.contentViewInsets.right)
			make.centerY.equalTo(nickNameLabel)
		}
		
		messageLabel.snp.makeConstraints { make in
			make.leading.equalTo(profileImageView.snp.trailing).offset(Constant.profileImageOutsets.right)
			make.bottom.equalTo(profileImageView)
		}
		
		newMessageCountLabel.snp.makeConstraints { make in
			make.width.greaterThanOrEqualTo(Constant.newMessageLabelSize.width)
			make.height.equalTo(Constant.newMessageLabelSize.height)
			make.centerY.equalTo(messageLabel)
			make.trailing.equalToSuperview().offset(-Constant.contentViewInsets.right)
			make.leading.equalTo(messageLabel.snp.trailing).offset(8)
		}
		
		newMessageCountLabel.setContentHuggingPriority(.init(755), for: .horizontal)
		newMessageCountLabel.setContentCompressionResistancePriority(.init(755), for: .horizontal)
	}
}
