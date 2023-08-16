//
//  DogProfileEditScrollView.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/08/01.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import DesignKit
import Entity
import GMDExtensions

enum ScrollViewConstant {
	static let maximumTextFieldCount = 20
	static let maximumTextViewCount = 100
}

final class DogProfileEditScrollView: UIScrollView {
	private let disposeBag = DisposeBag()

	var genderDidChanged = BehaviorRelay<Sex>(value: .male)
	var neuterDidChanged = BehaviorRelay<Bool>(value: true)
	
	// MARK: UI Property
	private let contentView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 24
		stackView.alignment = .fill
		stackView.distribution = .fillProportionally
		
		return stackView
	}()
	
	/// Scroll View Content
	fileprivate let nickNameTextField: GMDTextField = {
		let gmdTextField = GMDTextField(
			title: "닉네임",
			warningText: "닉네임을 입력해주세요."
		)
		
		return gmdTextField
	}()
	
	/// Display Max Count Text in nickNameTextField
	private let maximumTextCountLabel: UILabel = {
		let label = UILabel()
		label.textColor = .gray90
		label.font = .r15
		
		return label
	}()
	
	fileprivate let calenderTextField: GMDTextField = {
		let gmdTextField = GMDTextField(
			title: "생년월일",
			warningText: "생년월일을 입력해주세요."
		)
		
		return gmdTextField
	}()
	
	fileprivate let calenderButton: UIButton = {
		let button = UIButton()
		let image = UIImage(systemName: "calendar")
		button.tintColor = .black
		button.setImage(image, for: .normal)
		
		return button
	}()
	
	/// female, male button
	private let genderButtonStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 26
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	private let maleButton: GMDOptionButton = {
		let button = GMDOptionButton(title: "남")
		button.isSelected = true
		
		return button
	}()
	
	private let femaleButton = GMDOptionButton(title: "여")
	
	fileprivate let dogBreedTextField: GMDTextField = {
		let gmdTextField = GMDTextField(
			title: "우리 아이 종",
			warningText: "우리 아이 종을 작성해주세요"
		)
		
		return gmdTextField
	}()
	
	fileprivate let weightTextField: GMDTextField = {
		let gmdTextField = GMDTextField(
			title: "우리 아이 몸무게 (kg)",
			warningText: "우리 아이 몸무게 (kg)을 입력해주세요."
		)
		gmdTextField.textField.keyboardType = .numberPad
		
		return gmdTextField
	}()
	
	let suffix = "kg"
	
	/// stackView for "중성화" Label and RadioButton StackView
	private let neuterStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.spacing = 8
		stackView.distribution = .fillProportionally
		
		return stackView
	}()
	
	private let neuterStackViewLabel: UILabel = {
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
	
	private let didNeuterButton: GMDOptionButton = {
		let button = GMDOptionButton(title: "했어요")
		button.isSelected = true
		
		return button
	}()
	
	private let didNotNeuterButton = GMDOptionButton(title: "안 했어요")
	
	fileprivate let characterTextView = GMDTextView(title: "우리 아이 성격 (선택)")

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
		
		characterTextView.warningText = "\(ScrollViewConstant.maximumTextViewCount)자 이내로 입력 가능합니다."
		
		setupSubviews()
		setConstraints()
		bind()
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
		
		neuterStackView.addArrangedSubview(neuterStackViewLabel)
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

// MARK: Bind
private extension DogProfileEditScrollView {
	func bind() {
		rx.nickNameTextFieldText
			.orEmpty
			.withUnretained(self)
			.map { owner, text -> String in
				let maxTextCount = ScrollViewConstant.maximumTextFieldCount
				return owner.trimmingSuffix(text, maxCount: maxTextCount)
			}
			.bind(to: rx.nickNameTextFieldText)
			.disposed(by: disposeBag)
		
		rx.nickNameTextFieldText
			.orEmpty
			.map { "\($0.count)/\(ScrollViewConstant.maximumTextFieldCount)" }
			.bind(to: maximumTextCountLabel.rx.text)
			.disposed(by: disposeBag)

		calenderTextField.textField.rx.controlEvent(.editingDidBegin)
			.map { true }
			.bind(to: calenderTextField.textField.rx.isEditing)
			.disposed(by: disposeBag)

		weightTextField.textField.rx.controlEvent(.editingChanged)
			.withUnretained(self)
			.bind { owner, _ in
				owner.addSuffixForWeightTextField()
			}
			.disposed(by: disposeBag)
		
		weightTextField.textField.rx.cursorChanged
			.withUnretained(self)
			.bind { owner, range in
				owner.setUneditableSuffix(range)
			}
			.disposed(by: disposeBag)
		
		rx.characterTextViewText
			.orEmpty
			.map { "\($0.count)/\(ScrollViewConstant.maximumTextViewCount)" }
			.bind(to: characterTextView.maximumTextCountLabel.rx.text)
			.disposed(by: disposeBag)
		
		rx.characterTextViewText
			.orEmpty
			.map { $0.count > ScrollViewConstant.maximumTextViewCount }
			.bind(to: characterTextView.rx.isWarning)
			.disposed(by: disposeBag)
	}
}

// MARK: Bind Function
private extension DogProfileEditScrollView {
	func trimmingSuffix(_ text: String, maxCount: Int) -> String {
		if text.count >= maxCount {
			let index = text.index(text.startIndex, offsetBy: maxCount)
			return String(text[..<index])
		}
		return text
	}
	
	/// add Suffix in Weight TextField
	func addSuffixForWeightTextField() {
		let textField = weightTextField.textField
		guard let text = textField.text else { return }
		
		let suffix = suffix
		
		if text.contains(suffix), text.count == suffix.count {
			textField.text = ""
		} else if !text.contains(suffix) {
			textField.text = text + suffix
		}
	}
	
	/// uneditable suffic in Weight TextField
	func setUneditableSuffix(_ selectedRange: UITextRange?) {
		let textField = weightTextField.textField
		let suffix = suffix
		guard
			let text = textField.text,
			let selectedRange = selectedRange,
			let suffixRange = text.range(of: suffix)
		else {
			return
		}
		let suffixStartIndex = text.distance(
			from: text.startIndex,
			to: suffixRange.lowerBound
		)
		let cursorEndPosition = textField.offset(
			from: textField.beginningOfDocument,
			to: selectedRange.end
		)
		
		if
			cursorEndPosition > suffixStartIndex,
			let newPosition = textField.position(from: selectedRange.end, offset: -2) {
			textField.selectedTextRange = textField.textRange(
				from: newPosition,
				to: newPosition
			)
		}
	}
	
	func maleButtonDidTap() {
		if maleButton.isSelected == true { return }
		
		genderDidChanged.accept(.male)
		maleButton.isSelected = true
		femaleButton.isSelected = false
	}
	
	func femaleButtonDidTap() {
		if femaleButton.isSelected == true { return }
		
		genderDidChanged.accept(.female)
		femaleButton.isSelected = true
		maleButton.isSelected = false
	}
		
	func didNeuterButtonDidTap() {
		if didNeuterButton.isSelected == true { return }
		
		neuterDidChanged.accept(true)
		didNeuterButton.isSelected = true
		didNotNeuterButton.isSelected = false
	}
	
	func didNotNeuterButtonDidTap() {
		if didNotNeuterButton.isSelected == true { return }
		
		neuterDidChanged.accept(false)
		didNotNeuterButton.isSelected = true
		didNeuterButton.isSelected = false
	}
}

// MARK: Reactive Extension About ScrollView TextField/TextView
extension Reactive where Base: DogProfileEditScrollView {
	var nickNameTextFieldText: ControlProperty<String?> {
		base.nickNameTextField.textField.rx.text
	}
	var calenderTextFieldText: ControlProperty<String?> {
		base.calenderTextField.textField.rx.text
	}
	var dogBreedTextFieldText: ControlProperty<String?> {
		base.calenderTextField.textField.rx.text
	}
	var weightTextFieldText: ControlProperty<String?> {
		base.weightTextField.textField.rx.text
	}
	var characterTextViewText: ControlProperty<String?> {
		base.characterTextView.textView.rx.text
	}
}

// MARK: Reactive Extension About ScrollView Button
extension Reactive where Base: DogProfileEditScrollView {
	var didTapCalenderButton: ControlEvent<Void> {
		base.calenderButton.rx.tap
	}
}
