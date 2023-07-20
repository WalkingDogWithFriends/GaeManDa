//
//  DogsCollectionViewCell.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import DesignKit
import Entity

final class DogsCollectionViewCell: UICollectionViewCell {
	static let idenfier = "DogsCollectionViewCell"
	
	lazy var editButtonTap: Observable<Void> = {
		return editButton.rx.tap.asObservable()
	}()
	
	private let roundImageView: RoundImageView = {
		let imageView = RoundImageView()
		imageView.backgroundColor = .systemGray
		
		return imageView
	}()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .r12
		
		return label
	}()
	
	private let editButton: UIButton = {
		let button = UIButton()
		button.setTitle("수정", for: .normal)
		button.titleLabel?.font = .r8
		button.setTitleColor(.black, for: .normal)
		button.layer.borderColor = UIColor.gray50.cgColor
		button.layer.borderWidth = 1
		button.layer.cornerRadius = 10
		
		return button
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
		label.font = .r10
		label.text = "몸무게"
		
		return label
	}()
	
	private let weightValueLabel: UILabel = {
		let label = UILabel()
		label.font = .r8
		
		return label
	}()
	
	private let neuteringLabel: UILabel = {
		let label = UILabel()
		label.font = .r10
		label.text = "중성화"
		
		return label
	}()
	
	private let neuteringValueLabel: UILabel = {
		let label = UILabel()
		label.font = .r8
		
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupUI()
	}
	

	override func prepareForReuse() {
		super.prepareForReuse()
	}
}

// MARK: UI Setting
private extension DogsCollectionViewCell {
	func setupUI() {
		self.contentView.backgroundColor = .clear
		
		setupSubviews()
		setConstraints()
	}
	
	func setupSubviews() {
		contentView.addSubview(roundImageView)
		contentView.addSubview(titleLabel)
		contentView.addSubview(editButton)
		contentView.addSubview(bottomStackView)
		
		bottomStackView.addArrangedSubview(weightStackView)
		bottomStackView.addArrangedSubview(neuteringStackView)
		
		weightStackView.addArrangedSubview(weightLabel)
		weightStackView.addArrangedSubview(weightValueLabel)
		
		neuteringStackView.addArrangedSubview(neuteringLabel)
		neuteringStackView.addArrangedSubview(neuteringValueLabel)
	}
	
	func setConstraints() {
		roundImageView.snp.makeConstraints { make in
			make.top.leading.equalToSuperview().offset(8)
			make.width.height.equalTo(36)
		}
		
		titleLabel.snp.makeConstraints { make in
			make.centerY.equalTo(roundImageView)
			make.leading.equalTo(roundImageView.snp.trailing).offset(12)
		}
		
		editButton.snp.makeConstraints { make in
			make.centerY.equalTo(roundImageView)
			make.trailing.equalToSuperview().offset(-8)
			make.width.equalTo(36)
			make.height.equalTo(16)
		}
		
		bottomStackView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(8)
			make.bottom.equalToSuperview().offset(-8)
		}
	}
}

// MARK: Configure
extension DogsCollectionViewCell {
	func configuration(_ dog: Dog) {
		titleLabel.text = "\(dog.name) (\(dog.sex) / \(dog.age))"
		
		weightValueLabel.text = "\(dog.weight)kg"
		if dog.didNeutered == true {
			neuteringValueLabel.text = "했어요"
		} else {
			neuteringValueLabel.text = "안 했어요"
		}
	}
}
