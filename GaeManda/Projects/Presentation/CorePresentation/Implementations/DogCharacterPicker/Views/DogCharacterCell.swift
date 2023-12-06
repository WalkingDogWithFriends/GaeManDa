//
//  DogCharacterCell.swift
//  CorePresentation
//
//  Created by jung on 11/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import SnapKit
import DesignKit

final class DogCharacterCell: UICollectionViewCell {
	// MARK: - Properties
	var isChoice: Bool = false {
		didSet {
			isChoice ? setChoiceMode() : setDisableMode()
		}
	}
	
	private(set) var characterId: Int = 0

	// MARK: - UI Components
	private let tagLabel: UILabel = {
		let label = UILabel()
		label.font = .r15
		label.textAlignment = .center
		
		return label
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
	
	// MARK: - Configure Method
	func configure(with viewModel: DogCharacterViewModel) {
		self.tagLabel.text = "# \(viewModel.character)"
		self.isChoice = viewModel.isChoice
		self.characterId = viewModel.id
	}
}

// MARK: - UI Methods
private extension DogCharacterCell {
	func setupUI() {
		self.layer.cornerRadius = 15
		self.layer.borderWidth = 1
		self.clipsToBounds = true
		
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		contentView.addSubview(tagLabel)
	}
	
	func setConstraints() {
		tagLabel.snp.makeConstraints { make in
			make.center.equalToSuperview()
			make.top.equalToSuperview().offset(4)
			make.bottom.equalToSuperview().offset(-4)
			make.leading.equalToSuperview().offset(8)
			make.trailing.equalToSuperview().offset(-8)
		}
	}
}

// MARK: - Private Methods
private extension DogCharacterCell {
	func setChoiceMode() {
		self.backgroundColor = .green100
		self.tagLabel.textColor = .white
		self.layer.borderColor = UIColor.green100.cgColor
	}
	
	func setDisableMode() {
		self.backgroundColor = .white
		self.tagLabel.textColor = .gray90
		self.layer.borderColor = UIColor.gray90.cgColor
	}
}
