//
//  LocationSearchButton.swift
//  OnBoardingImpl
//
//  Created by 김영균 on 12/20/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import SnapKit

final class LocationSearchButton: UIButton {
	private let underLine: UIView = {
		let underLine = UIView()
		underLine.backgroundColor = .black
		return underLine
	}()
	
	// MARK: - Initializers
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private extension LocationSearchButton {
	enum Constant {
		static let title = "도로명 또는 지번 주소를 입력해주세요."
		static let searchIcon = UIImage.iconSearch
	}
	
	func setupUI() {
		setViewAttributes()
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewAttributes() {
		let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.l13, .foregroundColor: UIColor.gray90]
		let attributeContainer = AttributeContainer(attributes)
		var configuration = UIButton.Configuration.plain()
		configuration.attributedTitle = AttributedString(Constant.title, attributes: attributeContainer)
		configuration.image = Constant.searchIcon
		configuration.imagePlacement = .leading
		configuration.imagePadding = 12
		configuration.contentInsets = .init(top: 6, leading: 0, bottom: 6, trailing: 0)
		contentHorizontalAlignment = .leading
		self.configuration = configuration
	}
	
	func setViewHierarchy() {
		addSubview(underLine)
	}
	
	func setConstraints() {
		underLine.snp.makeConstraints {
			$0.leading.trailing.bottom.equalToSuperview()
			$0.height.equalTo(1)
		}
	}
}
