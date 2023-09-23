//
//  TabBarButton.swift
//  Dev-GaeManda
//
//  Created by jung on 2023/07/18.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import DesignKit
import GMDExtensions

final class TabBarButton: UIView {
	// MARK: - Properties
	var isSelected: Bool = false {
		didSet {
			titleLabel.font = isSelected ? .b12 : .r12
		}
	}
	
	// MARK: - UI Components
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .r12
		label.textAlignment = .center
		
		return label
	}()
	
	private let imageView: UIImageView
	
	// MARK: - Initializers
	init(imageView: UIImageView, title: String) {
		self.imageView = imageView
		
		super.init(frame: .zero)
		titleLabel.text = title
		setupUI()
	}
	
	init(image: UIImage?, title: String) {
		imageView = UIImageView(image: image)
		super.init(frame: .zero)
		titleLabel.text = title
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError()
	}
}

// MARK: - UI Methods
private extension TabBarButton {
	func setupUI() {
		imageView.tintColor = .black
		
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		addSubviews(imageView, titleLabel)
	}
	func setConstraints() {
		imageView.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.leading.equalToSuperview()
			make.trailing.equalToSuperview()
		}
		
		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(imageView.snp.bottom).offset(8)
			make.leading.equalToSuperview()
			make.trailing.equalToSuperview()
			make.bottom.equalToSuperview()
		}
	}
}
