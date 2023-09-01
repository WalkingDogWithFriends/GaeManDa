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
	
	var dogSex: Sex = .male
	var dogNeutered: Bool = true
	
	// MARK: - UI Components
	private let contentView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 24
		stackView.alignment = .fill
		stackView.distribution = .fillProportionally
		
		return stackView
	}()
	
	/// Scroll View Content
	let nickNameTextField = GMDTextField(
		title: "닉네임",
		warningText: "닉네임을 입력해주세요."
	)
	
	/// Display Max Count Text in nickNameTextField
	let maxTextCountLabel: UILabel = {
		let label = UILabel()
		label.textColor = .gray90
		label.font = .r15
		
		return label
	}()
	
	let calenderTextField = GMDTextField(
		title: "생년월일",
		warningText: "생년월일을 입력해주세요."
	)
	
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
	
	let maleButton: GMDOptionButton = {
		let button = GMDOptionButton(title: "남")
		button.isSelected = true
		
		return button
	}()
	
	let femaleButton = GMDOptionButton(title: "여")
	
	let dogBreedTextField = GMDTextField(
		title: "우리 아이 종",
		warningText: "우리 아이 종을 작성해주세요"
	)
	
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
	
	let didNeuterButton: GMDOptionButton = {
		let button = GMDOptionButton(title: "했어요")
		button.isSelected = true
		
		return button
	}()
	
	let didNotNeuterButton = GMDOptionButton(title: "안 했어요")
	
	let characterTextView = GMDTextView(title: "우리 아이 성격 (선택)")
	
	// MARK: - Initializer
	init() {
		super.init(frame: .zero)
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError()
	}
}

// MARK: - UI Setting
private extension DogProfileEditScrollView {
	func setupUI() {
		backgroundColor = .clear
		showsVerticalScrollIndicator = false
		
		nickNameTextField.textField.rightView = maxTextCountLabel
		nickNameTextField.textField.rightViewMode = .always
		
		calenderTextField.textField.rightView = calenderButton
		calenderTextField.textField.rightViewMode = .always
		
		characterTextView.warningText = "\(ScrollViewConstant.maximumTextViewCount)자 이내로 입력 가능합니다."
		
		setViewHierarchy()
		setConstraints()
		textBind()
		buttonBind()
	}
	
	func setViewHierarchy() {
		addSubview(contentView)
		contentView.addArrangedSubviews(
			nickNameTextField,
			calenderTextField,
			genderButtonStackView,
			dogBreedTextField,
			weightTextField,
			neuterStackView,
			characterTextView
		)
		
		genderButtonStackView.addArrangedSubviews(maleButton, femaleButton)
		
		neuterStackView.addArrangedSubviews(neuterStackViewLabel, neuterButtonStackView)
		
		neuterButtonStackView.addArrangedSubviews(didNeuterButton, didNotNeuterButton)
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

// MARK: - Bind
private extension DogProfileEditScrollView {
	func textBind() {
		nickNameTextField.textField.rx.text
			.orEmpty
			.map { text -> String in
				let maxTextCount = ScrollViewConstant.maximumTextFieldCount
				return text.trimmingSuffix(with: maxTextCount)
			}
			.bind(to: nickNameTextField.textField.rx.text)
			.disposed(by: disposeBag)
		
		nickNameTextField.textField.rx.text
			.orEmpty
			.map { "\($0.count)/\(ScrollViewConstant.maximumTextFieldCount)" }
			.bind(to: maxTextCountLabel.rx.text)
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
		
		characterTextView.textView.rx.text
			.orEmpty
			.map { "\($0.count)/\(ScrollViewConstant.maximumTextViewCount)" }
			.bind(to: characterTextView.maximumTextCountLabel.rx.text)
			.disposed(by: disposeBag)
		
		characterTextView.textView.rx.text
			.orEmpty
			.map { $0.count > ScrollViewConstant.maximumTextViewCount }
			.bind(to: characterTextView.rx.isWarning)
			.disposed(by: disposeBag)
	}
	
	func buttonBind() {
		maleButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.dogSex = .male
				owner.maleButton.rx.isSelected.onNext(true)
				owner.femaleButton.rx.isSelected.onNext(false)
			}
			.disposed(by: disposeBag)
		
		femaleButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.dogSex = .female
				owner.femaleButton.rx.isSelected.onNext(true)
				owner.maleButton.rx.isSelected.onNext(false)
			}
			.disposed(by: disposeBag)
		
		didNeuterButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.dogNeutered = true
				owner.didNeuterButton.rx.isSelected.onNext(true)
				owner.didNotNeuterButton.rx.isSelected.onNext(false)
			}
			.disposed(by: disposeBag)
		
		didNotNeuterButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.dogNeutered = false
				owner.didNotNeuterButton.rx.isSelected.onNext(true)
				owner.didNeuterButton.rx.isSelected.onNext(false)
			}
			.disposed(by: disposeBag)
	}
}

// MARK: Bind Function
private extension DogProfileEditScrollView {
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
}

// MARK: - Reactive Extension
extension Reactive where Base: DogProfileEditScrollView {
	var didTapCalenderButton: ControlEvent<Void> {
		base.calenderButton.rx.tap
	}
}
