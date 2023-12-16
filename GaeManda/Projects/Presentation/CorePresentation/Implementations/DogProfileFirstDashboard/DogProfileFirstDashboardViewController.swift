//
//  DogProfileFirstDashboardViewController.swift
//  CorePresentation
//
//  Created by jung on 12/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs
import RxCocoa
import RxSwift
import DesignKit
import Entity
import GMDUtils

// swiftlint:disable:next type_name
protocol DogProfileFirstDashboardPresentableListener: AnyObject {
	func viewDidLoad()
	func didTapCalenderButton()
	func didSelectedGender(_ gender: Gender)
	func didEnteredDogName(_ name: String)
	/// 잘못된 형식의 경우 -1 리턴 
	func didEnteredDogWeight(_ weight: Int)
}

final class DogProfileFirstDashboardViewController: 
	UIViewController,
	DogProfileFirstDashboardViewControllable {
	// MARK: - Constants
	private let maximumTextCount = 20

	// MARK: - Properties
	weak var listener: DogProfileFirstDashboardPresentableListener?
	var textDidChangeNotification: NSObjectProtocol?
	
	private let disposeBag = DisposeBag()
	private let selectedGender = BehaviorRelay<Gender>(value: .male)
	
	// MARK: - UI Components
	private let textStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.spacing = 8
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	private let buttonStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 26
		stackView.distribution = .fillEqually
		
		return stackView
	}()

	private let nameTextField = GMDTextField(title: "우리 아이 이름", warningText: "우리 아이 이름을 작성해주세요")
	
	private let maximumTextCountLabel: UILabel = {
		let label = UILabel()
		label.font = .r15
		label.textColor = .gray90
		
		return label
	}()

	private let calenderTextField = GMDTextField(title: "우리 아이 생년월일", warningText: "생년월일을 입력해주세요.")
	
	private let calenderButton: UIButton = {
		let button = UIButton()
		button.tintColor = .black
		button.setImage(.iconCalendar, for: .normal)
		
		return button
	}()
	
	private let weightTextField: GMDTextField = {
		let gmdTextField = GMDTextField(
			title: "우리 아이 몸무게 (kg)",
			warningText: "우리 아이 몸무게 (kg)을 입력해주세요."
		)
		gmdTextField.textField.keyboardType = .numberPad
		
		return gmdTextField
	}()
	
	private let maleButton = GMDOptionButton(title: "남", isSelected: true)
	private let femaleButton = GMDOptionButton(title: "여")
	
	// MARK: - Life Cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		
		textDidChangeNotification = registerTextFieldNotification()
		setupUI()
		listener?.viewDidLoad()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		removeTextFieldNotification(textDidChangeNotification)
	}
}

// MARK: - UI Methods
private extension DogProfileFirstDashboardViewController {
	func setupUI() {
		nameTextField.setRightView(maximumTextCountLabel)
		calenderTextField.setRightView(calenderButton)
		
		setViewHierarchy()
		setConstraints()
		bind()
	}
	
	func setViewHierarchy() {
		view.addSubviews(textStackView, buttonStackView)
		
		textStackView.addArrangedSubviews(nameTextField, calenderTextField, weightTextField)
		buttonStackView.addArrangedSubviews(maleButton, femaleButton)
	}
	
	func setConstraints() {
		textStackView.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
		}
		
		buttonStackView.snp.makeConstraints { make in
			make.top.equalTo(textStackView.snp.bottom).offset(28)
			make.leading.trailing.bottom.equalToSuperview()
			make.height.equalTo(40)
		}
	}
}

// MARK: - Bind Methods
private extension DogProfileFirstDashboardViewController {
	func bind() {
		bindTextField()
		bindButtons()
	}
	
	func bindTextField() {
		let trimmingTextObservable = nameTextField.rx.text
			.orEmpty
			.withUnretained(self)
			.map { owner, text in
				return text.trimmingSuffix(with: owner.maximumTextCount)
			}.asDriver(onErrorJustReturn: "")
		
		trimmingTextObservable
			.drive(nameTextField.rx.text)
			.disposed(by: disposeBag)
		
		trimmingTextObservable
			.drive(with: self) { owner, text in
				owner.maximumTextCountLabel.text =
				"\(text.count)/\(owner.maximumTextCount)"
			}
			.disposed(by: disposeBag)
		
		nameTextField.rx.text
			.orEmpty
			.distinctUntilChanged()
			.bind(with: self) { owner, name in
				owner.listener?.didEnteredDogName(name)
			}
			.disposed(by: disposeBag)
		
		weightTextField.rx.text
			.orEmpty
			.distinctUntilChanged()
			.map { Int($0) ?? -1 }
			.bind(with: self) { owner, weight in
				owner.listener?.didEnteredDogWeight(weight)
			}
			.disposed(by: disposeBag)
		
		// calenderTextField 편집 안되도록 합니다.
		calenderTextField.textField.rx.controlEvent(.editingDidBegin)
			.bind(with: self) { owner, _ in
				owner.calenderTextField.textField.endEditing(true)
			}
			.disposed(by: disposeBag)
	}
	
	func bindButtons() {
		calenderButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapCalenderButton()
			}
			.disposed(by: disposeBag)
		
		// 성별 버튼 선택 Observable
		Observable
			.merge(
				maleButton.rx.tap.map { Gender.male },
				femaleButton.rx.tap.map { Gender.female }
			)
			.bind(with: self) { owner, gender in
				owner.selectedGender.accept(gender)
			}
			.disposed(by: disposeBag)

		// 선택된 성별이 남성일 경우
		selectedGender
			.map { $0 == .male }
			.bind(to: maleButton.rx.isSelected)
			.disposed(by: disposeBag)
		
		// 선택된 성별이 여성일 경우
		selectedGender
			.map { $0 == .female }
			.bind(to: femaleButton.rx.isSelected)
			.disposed(by: disposeBag)
	}
}
// MARK: - DogProfileFirstDashboardPresentable
extension DogProfileFirstDashboardViewController: DogProfileFirstDashboardPresentable {
	func updateDog(_ viewModel: DogProfileFirstDashboardViewModel) {
		nameTextField.text = viewModel.name
		calenderTextField.text = viewModel.birthday
		weightTextField.text = "\(viewModel.weight)"
	}
	
	func updateNameTextFieldIsWarning() {
		nameTextField.mode = .warning
	}
	
	func updatebirthdayTextFieldIsWarning() {
		calenderTextField.mode = .warning
	}
	
	func updateWeightTextFieldIsWarning() {
		weightTextField.mode = .warning
	}
	
	func updateBirthday(date: String) {
		calenderTextField.text = date
	}
}

// MARK: - GMDTextFieldListener
extension DogProfileFirstDashboardViewController: GMDTextFieldListener {}
