//
//  UserProfileEditViewController.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import Entity
import GMDExtensions
import GMDUtils

protocol UserProfileEditPresentableListener: AnyObject {
	func viewWillAppear()
	func didTapBackbutton()
	func didTapEndEditingButton(name: String, sex: Sex)
}

final class UserProfileEditViewController:
	UIViewController,
	UserProfileEditPresentable,
	UserProfileEditViewControllable {
	// MARK: - Properties
	weak var listener: UserProfileEditPresentableListener?
	private let disposeBag = DisposeBag()
	
	private let maxTextCount = 20
	private let selectedSexRelay = BehaviorRelay<Sex>(value: .male)
	
	// MARK: - UI Components
	private let navigationBar = GMDNavigationBar(title: "프로필 수정")
	
	private let profileImageView: RoundImageView = {
		let roundImageView = RoundImageView()
		roundImageView.backgroundColor = .gray40
		
		return roundImageView
	}()
	
	/// GMDTextField StackView
	private let textStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.spacing = 16
		stackView.distribution = .fillProportionally
		
		return stackView
	}()
	
	private let nickNameTextField = GMDTextField(
		title: "닉네임",
		warningText: "닉네임을 입력해주세요."
	)
	
	/// Display Max Count Text in nickNameTextField
	private let maxTextCountLabel: UILabel = {
		let label = UILabel()
		label.textColor = .gray90
		label.font = .r15
		
		return label
	}()
	
	private let calenderTextField = GMDTextField(
		title: "생년월일",
		warningText: "생년월일을 입력해주세요."
	)
	
	private let calenderButton: UIButton = {
		let button = UIButton()
		let image = UIImage(systemName: "calendar")
		button.tintColor = .black
		button.setImage(image, for: .normal)
		
		return button
	}()
	
	/// GMDRadioButton StackView
	private let buttonStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 26
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	private let maleButton = GMDOptionButton(title: "남")
	private let femaleButton = GMDOptionButton(title: "여")
	
	private let confirmButton = ConfirmButton(title: "수정 완료")
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		listener?.viewWillAppear()
		
		hideTabBar()
	}
	// MARK: - touchesBegan
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		self.view.endEditing(true)
	}
}

// MARK: - UI Setting
private extension UserProfileEditViewController {
	func setupUI() {
		view.backgroundColor = .white
		self.navigationController?.navigationBar.isHidden = true
		maleButton.isSelected = true
		
		/// Set TextField Right View
		setTextField(nickNameTextField, rightView: maxTextCountLabel)
		setTextField(calenderTextField, rightView: calenderButton)
		
		setViewHierarchy()
		setConstraints()
		bind()
		bindForUI()
	}
	
	func setTextField(_ textField: GMDTextField, rightView: UIView) {
		textField.textField.rightView = rightView
		textField.textField.rightViewMode = .always
	}
	
	func setViewHierarchy() {
		view.addSubviews(
			navigationBar,
			profileImageView,
			textStackView,
			buttonStackView,
			confirmButton
		)
		
		textStackView.addArrangedSubviews(nickNameTextField, calenderTextField)
		
		buttonStackView.addArrangedSubviews(maleButton, femaleButton)
	}
	
	func setConstraints() {
		navigationBar.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(44)
		}
		
		profileImageView.snp.makeConstraints { make in
			make.top.equalTo(navigationBar.snp.bottom).offset(88)
			make.centerX.equalToSuperview()
			make.height.width.equalTo(140)
		}
		
		textStackView.snp.makeConstraints { make in
			make.top.equalTo(profileImageView.snp.bottom).offset(60)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
		}
		
		buttonStackView.snp.makeConstraints { make in
			make.top.equalTo(textStackView.snp.bottom).offset(44)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.height.equalTo(40)
		}
		
		confirmButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.bottom.equalToSuperview().offset(-54)
			make.height.equalTo(40)
		}
	}
}

// MARK: - UI Update
extension UserProfileEditViewController {
	func updateUsername(_ name: String) {
		nickNameTextField.text = name
	}
	
	func updateUserSex(_ sex: Sex) {
		selectedSexRelay.accept(sex)
	}
	
	func userNameIsEmpty() {
		nickNameTextField.mode = .warning
	}
}

// MARK: - Action Bind
private extension UserProfileEditViewController {
	func bind() {
		navigationBar.backButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapBackbutton()
			}
			.disposed(by: disposeBag)
	
		calenderButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.calenderButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		confirmButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapEndEditingButton(
					name: owner.nickNameTextField.text,
					sex: owner.selectedSexRelay.value
				)
			}
			.disposed(by: disposeBag)
	}
	
	// MARK: - UI Binding
	func bindForUI() {
		// textField의 text가 지정된 수보다 넘어가면 trimming
		nickNameTextField.rx.text
			.orEmpty
			.withUnretained(self)
			.map { owner, text -> NSAttributedString in
				text.trimmingSuffix(with: owner.maxTextCount).inputText()
			}
			.bind(to: nickNameTextField.rx.attributedText)
			.disposed(by: disposeBag)
	
		// textField의 text수를 알려주는 Label에 매핑
		nickNameTextField.rx.text
			.orEmpty
			.withUnretained(self)
			.map { "\($1.count)/\($0.maxTextCount)".inputText(color: .gray90) }
			.bind(to: maxTextCountLabel.rx.attributedText)
			.disposed(by: disposeBag)
		
		// calenderTextField가 editing안되도록 해줌.
		calenderTextField.textField.rx.controlEvent(.editingDidBegin)
			.map { true }
			.bind(to: calenderTextField.textField.rx.isEditing)
			.disposed(by: disposeBag)
		
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
	}
}

// MARK: - UI Logic
private extension UserProfileEditViewController {
	func calenderButtonDidTap() {
		print("calenderButtonDidTap")
	}
}
