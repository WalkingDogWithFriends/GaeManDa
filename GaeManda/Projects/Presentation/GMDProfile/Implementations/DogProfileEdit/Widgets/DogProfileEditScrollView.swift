//
//  DogProfileEditScrollView.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/08/01.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import DesignKit

final class DogProfileEditScrollView: UIScrollView {
	// MARK: UI Property
	let contentView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 24
		stackView.alignment = .fill
		stackView.distribution = .fillProportionally
		
		return stackView
	}()
	
	/// Scroll View Content
	let nickNameTextField: GMDTextField = {
		let gmdTextField = GMDTextField(
			title: "닉네임",
			warningText: "닉네임을 입력해주세요."
		)
		
		return gmdTextField
	}()
	
	var maximumTextFieldCount = 20
	
	/// Display Max Count Text in nickNameTextField
	lazy var maximumTextCountLabel: UILabel = {
		let label = UILabel()
		label.textColor = .gray90
		label.font = .r15
		
		return label
	}()
	
	let calenderTextField: GMDTextField = {
		let gmdTextField = GMDTextField(
			title: "생년월일",
			warningText: "생년월일을 입력해주세요."
		)
		
		return gmdTextField
	}()
	
	let calenderButton: UIButton = {
		let button = UIButton()
		let image = UIImage(systemName: "calendar")
		button.tintColor = .black
		button.setImage(image, for: .normal)
		
		return button
	}()
	
	/// female, male button
	let genderButtonStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 26
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	let maleButton: GMDOptionButton = {
		let button = GMDOptionButton(title: "남")
		button.isSelected = true
		
		return button
	}()
	
	let femaleButton = GMDOptionButton(title: "여")
	
	let dogBreedTextField: GMDTextField = {
		let gmdTextField = GMDTextField(
			title: "우리 아이 종",
			warningText: "우리 아이 종을 작성해주세요"
		)
		
		return gmdTextField
	}()
	
	let weightTextField: GMDTextField = {
		let gmdTextField = GMDTextField(
			title: "우리 아이 몸무게 (kg)",
			warningText: "우리 아이 몸무게 (kg)을 입력해주세요."
		)
		gmdTextField.textField.keyboardType = .numberPad
		
		return gmdTextField
	}()
	
	let suffix = "kg"
	
	/// stackView for "중성화" Label and RadioButton StackView
	let neuterStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.spacing = 8
		stackView.distribution = .fillProportionally
		
		return stackView
	}()
	
	let neuterRadioButtonLabel: UILabel = {
		let label = UILabel()
		label.text = "중성화"
		label.font = .r12
		label.textColor = .gray90
		
		return label
	}()
	
	private let neuterButtonStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 26
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	let didNeuterButton: GMDOptionButton = {
		let button = GMDOptionButton(title: "했어요")
		button.isSelected = true
		
		return button
	}()
	
	let didNotNeuterButton = GMDOptionButton(title: "안 했어요")
	
	let characterTextView = GMDTextView(title: "우리 아이 성격 (선택)")
	
	var maximumTextViewCount: Int = 100
	
	// MARK: Initializer
	init() {
		super.init(frame: .zero)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError()
	}
}

// MARK: Setting UI
private extension DogProfileEditScrollView {
	func setupUI() {
		backgroundColor = .clear
		showsVerticalScrollIndicator = true
		
		nickNameTextField.textField.rightView = maximumTextCountLabel
		nickNameTextField.textField.rightViewMode = .always
		
		calenderTextField.textField.rightView = calenderButton
		calenderTextField.textField.rightViewMode = .always
		
		characterTextView.warningText = "\(maximumTextViewCount)자 이내로 입력 가능합니다."
		characterTextView.maximumTextCountLabel.text = "0/\(maximumTextViewCount)"
		
		setupSubviews()
		setConstraints()
	}
	
	func setupSubviews() {
		addSubview(contentView)
		contentView.addArrangedSubview(nickNameTextField)
		contentView.addArrangedSubview(calenderTextField)
		contentView.addArrangedSubview(genderButtonStackView)
		contentView.addArrangedSubview(dogBreedTextField)
		contentView.addArrangedSubview(weightTextField)
		contentView.addArrangedSubview(neuterStackView)
		contentView.addArrangedSubview(characterTextView)
		
		genderButtonStackView.addArrangedSubview(maleButton)
		genderButtonStackView.addArrangedSubview(femaleButton)
		
		neuterStackView.addArrangedSubview(neuterRadioButtonLabel)
		neuterStackView.addArrangedSubview(neuterButtonStackView)
		
		neuterButtonStackView.addArrangedSubview(didNeuterButton)
		neuterButtonStackView.addArrangedSubview(didNotNeuterButton)
	}
	
	func setConstraints() {
		contentView.snp.makeConstraints { make in
			make.top.leading.trailing.bottom.equalToSuperview()
			make.width.equalToSuperview()
		}
		
		nickNameTextField.snp.makeConstraints { make in
			make.top.equalToSuperview()
		}
		
		genderButtonStackView.snp.makeConstraints { make in
			make.height.equalTo(40)
			make.width.equalToSuperview()
		}
		
		neuterButtonStackView.snp.makeConstraints { make in
			make.height.equalTo(40)
			make.width.equalToSuperview()
		}
		
		characterTextView.snp.makeConstraints { make in
			make.bottom.equalToSuperview()
		}
	}
}
