//
//  UserProfileDashboardViewController.swift
//  CorePresentation
//
//  Created by jung on 12/14/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs
import RxCocoa
import RxSwift
import CorePresentation
import DesignKit
import Entity
import GMDUtils

protocol UserProfileDashboardPresentableListener: AnyObject {
	func viewDidLoad()
	func calenderButtonDidTap()
	func didSelectedGender(_ gender: Gender)
	func didEnteredUserName(_ name: String)
}

final class UserProfileDashboardViewController:
	UIViewController,
	UserProfileDashboardViewControllable {
	// MARK: - Properties
	weak var listener: UserProfileDashboardPresentableListener?
	var textDidChangeNotification: NSObjectProtocol?

	private let disposeBag = DisposeBag()
	private let maximumTextCount = 20
	
	private let selectedGender = BehaviorRelay<Gender>(value: .male)
	
	// MARK: - UI Components
	private let nickNameTextField = UserNameTextField(title: "닉네임")
	private let maximumTextCountLabel: UILabel = {
		let label = UILabel()
		label.font = .r15
		label.textColor = .gray90
		
		return label
	}()
	private let calenderTextField = GMDTextField(title: "생년월일", warningText: "생년월일을 입력해주세요.")
	
	private let calenderButton: UIButton = {
		let button = UIButton()
		button.tintColor = .black
		button.setImage(.iconCalendar, for: .normal)
		
		return button
	}()
	
	private let buttonStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 26
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	private let maleButton = GMDOptionButton(title: "남", isSelected: true)
	private let femaleButton = GMDOptionButton(title: "여")
	
	// MARK: - Life Cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		listener?.viewDidLoad()
		
		textDidChangeNotification = registerTextFieldNotification()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		removeTextFieldNotification(textDidChangeNotification)
	}
}

// MARK: - UI Methods
private extension UserProfileDashboardViewController {
	func setupUI() {
		nickNameTextField.setRightView(maximumTextCountLabel)
		calenderTextField.setRightView(calenderButton)
		
		setViewHierarchy()
		setConstraints()
		bind()
	}
	
	func setViewHierarchy() {
		view.addSubviews(nickNameTextField, calenderTextField, buttonStackView)
		buttonStackView.addArrangedSubviews(maleButton, femaleButton)
	}
	
	func setConstraints() {
		nickNameTextField.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
		}
		
		calenderTextField.snp.makeConstraints { make in
			make.top.equalTo(nickNameTextField.snp.bottom).offset(16)
			make.leading.trailing.equalToSuperview()
		}
		
		buttonStackView.snp.makeConstraints { make in
			make.top.equalTo(calenderTextField.snp.bottom).offset(44)
			make.height.equalTo(40)
			make.leading.trailing.bottom.equalToSuperview()
		}
	}
}

// MARK: - UserProfileDashboardPresentable
extension UserProfileDashboardViewController: UserProfileDashboardPresentable {
	func updateNameTextMode(_ textFieldMode: NicknameTextFieldMode) {
		nickNameTextField.mode = textFieldMode
	}
	
	func updatebirthdayTextFieldIsWarning(_ isWarning: Bool) {
		self.calenderTextField.mode = isWarning ? .warning : .normal
	}
	
	func updateUser(_ viewModel: UserProfileDashboardViewModel) {
		nickNameTextField.text = viewModel.name
		calenderTextField.text = viewModel.birthday
		selectedGender.accept(viewModel.gender)
	}
	
	func updateBirthday(date: String) {
		calenderTextField.text = date
	}
}

// MARK: - Bind Methods
private extension UserProfileDashboardViewController {
	func bind() {
		selectedGender.distinctUntilChanged()
			.bind(with: self) { owner, gender in
				owner.listener?.didSelectedGender(gender)
			}
			.disposed(by: disposeBag)
		
		bindTextField()
		bindButtons()
	}
	
	func bindTextField() {
		let trimmingTextObservable = nickNameTextField.rx.text
			.orEmpty
			.withUnretained(self)
			.map { owner, text in
				return text.trimmingSuffix(with: owner.maximumTextCount)
			}.asDriver(onErrorJustReturn: "")
		
		trimmingTextObservable
			.drive(nickNameTextField.rx.text)
			.disposed(by: disposeBag)
		
		trimmingTextObservable
			.drive(with: self) { owner, text in
				owner.maximumTextCountLabel.text =
				"\(text.count)/\(owner.maximumTextCount)"
			}
			.disposed(by: disposeBag)
		
		nickNameTextField.rx.text
			.orEmpty
			.map { $0.isEmpty ? 0 : 1.0 }
			.bind(to: nickNameTextField.rx.titleAlpha)
			.disposed(by: disposeBag)
		
		// 실시간 피드백
		nickNameTextField.rx.text
			.orEmpty
			.skip(1)
			.debounce(.microseconds(50), scheduler: MainScheduler.asyncInstance)
			.bind(with: self) { owner, name in
				owner.listener?.didEnteredUserName(name)
			}
			.disposed(by: disposeBag)
		
		calenderTextField.textField.rx.controlEvent(.editingDidBegin)
			.bind(with: self) { owner, _ in
				owner.calenderTextField.textField.endEditing(true)
			}
			.disposed(by: disposeBag)
	}
	
	func bindButtons() {
		calenderButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.calenderButtonDidTap()
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

// MARK: - GMDTextFieldListener
extension UserProfileDashboardViewController: GMDTextFieldListener { }
