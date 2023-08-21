//
//  DateCell.swift
//  ChattingImpl
//
//  Created by jung on 2023/08/21.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import SnapKit
import DesignKit
import GMDExtensions

final class DateCell: UITableViewCell {
	// MARK: - UI Components
	private let dateLabel: UILabel = {
		let label = UILabel()
		label.textColor = .gray80
		label.textAlignment = .center
		
		return label
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
	func configure(with date: String) {
		dateLabel.text = date
	}
}

// MARK: - UI Setting
private extension DateCell {
	func setupUI() {
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		contentView.addSubview(dateLabel)
	}
	
	func setConstraints() {
		dateLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(10)
			make.bottom.equalToSuperview().offset(-27)
			make.centerX.equalToSuperview()
		}
	}
}
