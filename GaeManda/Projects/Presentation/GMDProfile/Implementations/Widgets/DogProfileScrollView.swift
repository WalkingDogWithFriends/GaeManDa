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
}

final class DogProfileScrollView: UIScrollView {
	// MARK: - Properties
	private let disposeBag = DisposeBag()
	private let kgSuffix = "kg"
	
	let selectedSexRelay = BehaviorRelay<Sex>(value: .male)
	let selectedNeuterRelay = BehaviorRelay<Neutered>(value: .true)
	let textFieldModeRelay = BehaviorRelay<ScollViewUIComponentMode>(value: ScollViewUIComponentMode())
	
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
	let nickNameTextField = GMDTextField(title: "닉네임", warningText: "닉네임을 입력해주세요.")
	
	/// Display Max Count Text in nickNameTextField
	let maxTextCountLabel: UILabel = {
		let label = UILabel()
		label.textColor = .gray90
		label.font = .r15
		
		return label
	}()
	
	let calenderTextField = GMDTextField(title: "생년월일", warningText: "생년월일을 입력해주세요.")
	
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
	let dogBreedTextField = GMDTextField(title: "우리 아이 종", warningText: "우리 아이 종을 작성해주세요")
	
	let weightTextField: GMDTextField = {
		let gmdTextField = GMDTextField(
			title: "우리 아이 몸무게 (kg)",
			warningText: "우리 아이 몸무게 (kg)을 입력해주세요."
		)
		gmdTextField.textField.keyboardType = .numberPad
		
		return gmdTextField
	}()
	
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
	let characterTextView: GMDTextView = GMDTextView(title: "우리 아이 성격 (선택)")
	
	// MARK: - Initializer
	init() {
		super.init(frame: .zero)
		showsVerticalScrollIndicator = false
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError()
	}
}

// MARK: - UI Setting
private extension DogProfileScrollView {
	func setupUI() {
		setTextField(nickNameTextField, rightView: maxTextCountLabel)
		setTextField(calenderTextField, rightView: calenderButton)
		
		setViewHierarchy()
		setConstraints()
		textFieldBind()
		textViewBind()
		buttonBind()
	}
	
	func setTextField(_ textField: GMDTextField, rightView: UIView) {
		textField.textField.rightView = rightView
		textField.textField.rightViewMode = .always
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
private extension DogProfileScrollView {
	func textFieldBind() {
		nickNameTextFieldBind()
		calenderTextFieldBind()
		dogBreedTextFieldBind()
		dogWeightTextFieldBind()
	}
	
	func nickNameTextFieldBind() {
		// textField의 text가 지정된 수보다 넘어가면 trimming해줌.
		nickNameTextField.rx.text.orEmpty
			.map { text in
				let maxTextCount = ScrollViewConstant.maximumTextFieldCount
				return text.trimmingSuffix(with: maxTextCount).inputText()
			}
			.bind(to: nickNameTextField.rx.attributedText)
			.disposed(by: disposeBag)
		
		// textField의 text수를 알려주는 Label에 매핑해줌.
		nickNameTextField.rx.text.orEmpty
			.map { "\($0.count)/\(ScrollViewConstant.maximumTextFieldCount)".inputText(color: .gray90) }
			.bind(to: maxTextCountLabel.rx.attributedText)
			.disposed(by: disposeBag)
	}
	
	func calenderTextFieldBind() {
		// calenderTextField가 editing안되도록 해줌.
		calenderTextField.textField.rx.controlEvent(.editingDidBegin)
			.map { true }
			.bind(to: calenderTextField.textField.rx.isEditing)
			.disposed(by: disposeBag)
	}
	
	func dogBreedTextFieldBind() { }
	
	func dogWeightTextFieldBind() {
		// kg suffix를 붙여줌.
		weightTextField.rx.text.orEmpty
			.filter { !$0.isEmpty }
			.map { $0.append(suffix: "kg") }
			.bind(to: weightTextField.rx.text)
			.disposed(by: disposeBag)
		
		// suffix부분에 커서가 이동이 안되도록 해줌.
		weightTextField.textField.rx.cursorChanged
			.bind(with: self) { owner, _ in
				owner.weightTextField.textField.moveCusorLeftTo(suffix: "kg")
			}
			.disposed(by: disposeBag)
	}
		
	func textViewBind() {
		// "0/100"과 같이 maxTextCount를 bind시켜줌.
		characterTextView.rx.text.orEmpty
			.withUnretained(self)
			.map { owner, text in
				"\(text.count)/\(owner.characterTextView.maxTextCount)" }
			.bind(to: characterTextView.maximumTextCountLabel.rx.text)
			.disposed(by: disposeBag)
		
		let characterTextViewModeObservable = characterTextView.rx.text.orEmpty
			.withUnretained(self)
			.map { owner, text in
				text.count > owner.characterTextView.maxTextCount
				? GMDTextViewMode.warning : GMDTextViewMode.normal
			}.asDriver(onErrorJustReturn: .normal)
		
		// GMDTextView의 모드를 변경시켜줌
		characterTextViewModeObservable
			.drive(characterTextView.rx.mode)
			.disposed(by: disposeBag)
		
		// ScrollViewUIComponentMode를 생성해서 전달해줌.
		Observable
			.combineLatest(
				nickNameTextField.rx.text.orEmpty,
				dogBreedTextField.rx.text.orEmpty,
				weightTextField.rx.text.orEmpty,
				characterTextViewModeObservable.asObservable()
			)
			.map {
				ScollViewUIComponentMode(
					nickNameTextFieldMode: $0.0.isEmpty ? .warning : .normal,
					dogBreedTextFieldMode: $0.1.isEmpty ? .warning : .normal,
					dogWeightTextFieldMode: $0.2.isEmpty ? .warning : .normal,
					characterTextViewMode: $0.3
				)
			}
			.subscribe(with: self) { owner, viewModel in
				owner.textFieldModeRelay.accept(viewModel)
			}
			.disposed(by: disposeBag)
	}
	
	func buttonBind() {
		// 성별 버튼 선택 Observable
		Observable.merge(
			maleButton.rx.tap.map { Sex.male },
			femaleButton.rx.tap.map { Sex.female }
		)
		.subscribe(with: self) { owner, sex in
			owner.selectedSexRelay.accept(sex)
		}
		.disposed(by: disposeBag)
		
		// 남자일 경우
		selectedSexRelay
			.map { $0 == .male }
			.bind(to: maleButton.rx.isSelected)
			.disposed(by: disposeBag)
		
		// 여성일 경우
		selectedSexRelay
			.map { $0 == .female }
			.bind(to: femaleButton.rx.isSelected)
			.disposed(by: disposeBag)
		
		// 중성화 버튼 선택 Observable
		Observable.merge(
			didNeuterButton.rx.tap.map { Neutered.true },
			didNotNeuterButton.rx.tap.map { Neutered.false }
		)
		.subscribe(with: self) { owner, neutered in
			owner.selectedNeuterRelay.accept(neutered)
		}
		.disposed(by: disposeBag)
		
		// 중성화 한 경우
		selectedNeuterRelay
			.map { $0 == .true }
			.bind(to: didNeuterButton.rx.isSelected)
			.disposed(by: disposeBag)
		
		// 중성화 안한 경우
		selectedNeuterRelay
			.map { $0 == .false }
			.bind(to: didNotNeuterButton.rx.isSelected)
			.disposed(by: disposeBag)
	}
}

// MARK: - Reactive Extension
extension Reactive where Base: DogProfileScrollView {
	var didTapCalenderButton: ControlEvent<Void> {
		base.calenderButton.rx.tap
	}
}
