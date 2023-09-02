//
//  DogProfileDashBoardCell.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/08/01.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import SnapKit
import DesignKit
import Entity

final class DogProfileDashBoardCell: UICollectionViewCell {
	// MARK: - Properties
	private let selectedColor = UIColor.green100.cgColor
	private let deselectedColor = UIColor.white.cgColor
	
	// MARK: - UI Component
	private let imageView = RoundImageView()
	
	// MARK: - Initializers
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
		
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	// MARK: - Configure
	func configure(with dog: DogDashBoardViewModel) {
		imageView.image = UIImage()
		
		imageView.layer.borderColor = dog.isEdited ? selectedColor : deselectedColor
	}
}

// MARK: - UI Setting
private extension DogProfileDashBoardCell {
	func setupUI() {
		imageView.layer.borderWidth = 1
		imageView.backgroundColor = .gray40
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		contentView.addSubview(imageView)
	}
	
	func setConstraints() {
		imageView.snp.makeConstraints { make in
			make.height.width.equalTo(56)
			make.edges.trailing.equalToSuperview()
		}
	}
}
