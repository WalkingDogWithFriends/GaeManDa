//
//  SelectedDogCharacterCell.swift
//  CorePresentation
//
//  Created by jung on 12/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import Entity
import GMDExtensions

final class SelectedDogCharacterCell: UICollectionViewCell {
	// MARK: - Properties
	private(set) var characterId: Int = 0

	// MARK: - UI Components
	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.spacing = 4
		stackView.alignment = .fill
		stackView.distribution = .fillProportionally
		
		return stackView
	}()
	
	private let tagLabel: UILabel = {
		let label = UILabel()
		label.font = .r15
		label.textAlignment = .center
		
		return label
	}()
	
	fileprivate let deleteButton: UIButton = {
		let button = UIButton()
		let image = UIImage(systemName: "xmark")?.applyingSymbolConfiguration(.init(pointSize: 12))

		button.setImage(image, for: .normal)
		button.tintColor = .white
		
		return button
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
	func configure(with data: DogCharacter) {
		self.tagLabel.text = "\(data.character)"
		self.characterId = data.id
	}
}

// MARK: - UI Methods
private extension SelectedDogCharacterCell {
	func setupUI() {
		self.layer.cornerRadius = 15
		self.clipsToBounds = true
		self.backgroundColor = .green100
		self.tagLabel.textColor = .white

		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		contentView.addSubview(stackView)
		stackView.addArrangedSubviews(tagLabel, deleteButton)
	}
	
	func setConstraints() {
		stackView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(4)
			make.bottom.equalToSuperview().offset(-4)
			make.leading.equalToSuperview().offset(8)
			make.trailing.equalToSuperview().offset(-8)
		}
	}
}

// MARK: - Reactive Extension
extension Reactive where Base: SelectedDogCharacterCell {
	var didTapDeleteButton: ControlEvent<Void> {
		return base.deleteButton.rx.tap
	}
}
