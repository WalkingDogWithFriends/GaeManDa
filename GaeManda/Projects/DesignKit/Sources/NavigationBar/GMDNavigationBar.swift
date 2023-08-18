//
//  GMDNavigationBar.swift
//  DesignKit
//
//  Created by 김영균 on 2023/08/07.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import SnapKit

public final class GMDNavigationBar: UIView {
	// MARK: - UI Components
	public let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .b20
		label.textColor = .black
		return label
	}()
	
	public let backButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.iconChevronLeft, for: .normal)
		return button
	}()
	
	private let rightView: UIStackView = {
		let view = UIStackView()
		view.axis = .horizontal
		view.spacing = 20
		return view
	}()
	
	public private(set) var rightItems: [GMDNavigationItem]?
	
	// MARK: - Initializers
	public init(title: String, rightItems: [GMDNavigationItemType] = []) {
		self.rightItems = rightItems.map(GMDNavigationItem.init(type:))
		
		super.init(frame: .zero)
		
		titleLabel.text = title
		setViewHierarchy()
		setViewConstraints()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private extension GMDNavigationBar {
	func setViewHierarchy() {
		if let rightItems = rightItems {
			rightItems.forEach(rightView.addArrangedSubview)
		}
		addSubviews(titleLabel, backButton, rightView)
	}
	
	func setViewConstraints() {
		titleLabel.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
		}
		backButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(24)
			make.centerY.equalToSuperview()
		}
		rightView.snp.makeConstraints { make in
			make.trailing.equalToSuperview().offset(-24)
			make.centerY.equalToSuperview()
		}
	}
}
