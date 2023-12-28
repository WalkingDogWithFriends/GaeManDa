//
//  DogInfoCell.swift
//  GMDMapImpl
//
//  Created by jung on 12/28/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import SnapKit
import GMDUtils
import DesignKit

final class DogInfoCell: UITableViewCell { 
	// MARK: - UI Components
	private let profileImageView = RoundImageView()
	private let dogNameLabel: UILabel = {
		let label = UILabel()
		label.font = .r15
		return label
	}()
	
	private let sexAndAgeLabel: UILabel = {
		let label = UILabel()
		label.font = .r12
		label.textColor = .gray90
		
		return label
	}()
	
	private let sendButton: UIButton = {
		let button = UIButton()
		button.setTitle("전송", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.titleLabel?.font = .r12
		
		button.layer.cornerRadius = 8
		button.backgroundColor = .green100
		
		return button
	}()
	
	private let characterLabel: UILabel = {
		let label = UILabel()
		label.font = .r12
		return label
	}()
	
	// MARK: - Initializers
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	// MARK: - Configure Methods
	func configure(with dog: MapDog) {
		profileImageView.loadImage(urlString: dog.profileImageURL)
		dogNameLabel.text = dog.name
		sexAndAgeLabel.text = "\(dog.gender) / \(dog.age)"
		characterLabel.text = "\(dog.character)"
	}
}

// MARK: UI Methods
private extension DogInfoCell {
	func setupUI() {
		setViewHeirarchy()
		setConstraints()
	}
	
	func setViewHeirarchy() { 
		contentView.addSubviews(profileImageView, dogNameLabel, sexAndAgeLabel, sendButton, characterLabel)
	}
	
	func setConstraints() {
		profileImageView.snp.makeConstraints { make in
			make.height.width.equalTo(60)
			make.centerY.equalToSuperview()
			make.top.bottom.leading.equalToSuperview().inset(8)
		}
		
		dogNameLabel.snp.makeConstraints { make in
			make.leading.equalTo(profileImageView.snp.trailing).offset(12)
			make.top.equalTo(profileImageView)
		}
		
		sexAndAgeLabel.snp.makeConstraints { make in
			make.leading.equalTo(dogNameLabel.snp.trailing).offset(10)
			make.centerY.equalTo(dogNameLabel)
		}
		
		characterLabel.snp.makeConstraints { make in
			make.leading.equalTo(dogNameLabel)
			make.bottom.equalTo(profileImageView)
			make.trailing.equalToSuperview().offset(-8)
		}
		
		sendButton.snp.makeConstraints { make in
			make.centerY.equalTo(dogNameLabel)
			make.height.equalTo(16)
			make.width.equalTo(52)
			make.trailing.equalTo(characterLabel)
		}
	}
}
