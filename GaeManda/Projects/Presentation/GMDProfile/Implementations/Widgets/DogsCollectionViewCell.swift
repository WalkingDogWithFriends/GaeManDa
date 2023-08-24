//
//  DogsCollectionViewCell.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import Entity
import GMDExtensions

final class DogsCollectionViewCell: UICollectionViewCell {
	// MARK: - UI Components
	private let profileImageView: RoundImageView = {
		let imageView = RoundImageView()
		imageView.backgroundColor = .systemGray
		
		return imageView
	}()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .r16
		
		return label
	}()
	
	private let buttonStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.spacing = 8
		stackView.alignment = .fill
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	private let bottomStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 4
		stackView.alignment = .fill
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	private let weightStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.spacing = 21
		stackView.alignment = .fill
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	private let neuteringStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.spacing = 21
		stackView.alignment = .fill
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	private let weightLabel: UILabel = {
		let label = UILabel()
		label.font = .r12
		label.text = "몸무게"
		
		return label
	}()
	
	private let weightValueLabel: UILabel = {
		let label = UILabel()
		label.font = .r12
		
		return label
	}()
	
	private let neuteringLabel: UILabel = {
		let label = UILabel()
		label.font = .r12
		label.text = "중성화"
		
		return label
	}()
	
	private let neuteringValueLabel: UILabel = {
		let label = UILabel()
		label.font = .r12
		
		return label
	}()
	
	// MARK: - UI Components(Button)
	fileprivate let editButton: UIButton = {
		let button = UIButton()
		let image = UIImage(
			systemName: "rectangle.and.pencil.and.ellipsis.rtl",
			withConfiguration: UIImage.SymbolConfiguration(pointSize: 18)
		)
		button.setImage(image, for: .normal)
		button.tintColor = .gray90
		
		return button
	}()
	
	fileprivate let deleteButton: UIButton = {
		let button = UIButton()
		let image = UIImage(
			systemName: "trash",
			withConfiguration: UIImage.SymbolConfiguration(pointSize: 18)
		)
		button.setImage(image, for: .normal)
		button.tintColor = .gray90
		
		return button
	}()
	
	// MARK: - Initializers
	override init(frame: CGRect) {
		super.init(frame: .zero)
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	// MARK: - Configure
	func configure(with dog: Dog) {
		titleLabel.text = "\(dog.name) (\(dog.sex) / \(dog.age)세)"
		
		weightValueLabel.text = "\(dog.weight)kg"
		neuteringValueLabel.text = dog.didNeutered == true ? "했어요" : "안 했어요"
	}
}

// MARK: - UI Setting
private extension DogsCollectionViewCell {
	func setupUI() {
		self.contentView.backgroundColor = .clear
		
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		contentView.addSubviews(
			profileImageView,
			titleLabel,
			buttonStackView,
			bottomStackView
		)
		buttonStackView.addArrangedSubviews(editButton, deleteButton)
		
		bottomStackView.addArrangedSubviews(weightStackView, neuteringStackView)
		
		weightStackView.addArrangedSubviews(weightLabel, weightValueLabel)
		
		neuteringStackView.addArrangedSubviews(neuteringLabel, neuteringValueLabel)
	}
	
	func setConstraints() {
		profileImageView.snp.makeConstraints { make in
			make.top.leading.equalToSuperview().offset(8)
			make.width.height.equalTo(36)
		}
		
		titleLabel.snp.makeConstraints { make in
			make.centerY.equalTo(profileImageView)
			make.leading.equalTo(profileImageView.snp.trailing).offset(12)
		}
		
		buttonStackView.snp.makeConstraints { make in
			make.centerY.equalTo(profileImageView)
			make.trailing.equalToSuperview().offset(-8)
		}
		
		bottomStackView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(8)
			make.top.equalTo(profileImageView.snp.bottom).offset(-8)
			make.bottom.equalToSuperview().offset(-12)
		}
	}
}

// MARK: Reactive Extension
extension Reactive where Base: DogsCollectionViewCell {
	var editButtonDidTapped: ControlEvent<Void> {
		base.editButton.rx.tap
	}
	
	var deleteButtonDidTapped: ControlEvent<Void> {
		base.deleteButton.rx.tap
	}
}
