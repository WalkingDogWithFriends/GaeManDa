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
	weak var listener: UserProfileEditPresentableListener?
	private let disposeBag = DisposeBag()
	
	var userGender: Sex = .male
	// MARK: - Constant Properties
	let maxTextCount = 20
	
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
	
	private let endEditingButton: UIButton = {
		let button = UIButton()
		button.setTitle("수정 완료", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.layer.cornerRadius = 4
		button.backgroundColor = .green100
		button.titleLabel?.font = .b16
		
		return button
	}()
	
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
}

// MARK: - UI Setting
private extension UserProfileEditViewController {
	func setupUI() {
		view.backgroundColor = .white
		self.navigationController?.navigationBar.isHidden = true
		maleButton.isSelected = true
		
		/// Set TextField Right View
		nickNameTextField.textField.rightView = maxTextCountLabel
		nickNameTextField.textField.rightViewMode = .always
		
		calenderTextField.textField.rightView = calenderButton
		calenderTextField.textField.rightViewMode = .always
		
		setViewHierarchy()
		setConstraints()
		bind()
		bindForUI()
	}
	
	func setViewHierarchy() {
		view.addSubviews(
			navigationBar,
			profileImageView,
			textStackView,
			buttonStackView,
			endEditingButton
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
		
		endEditingButton.snp.makeConstraints { make in
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
		nickNameTextField.titleLabel.alpha = name.isEmpty ? 0.0 : 1.0
		maxTextCountLabel.text = "\(name.count)/\(maxTextCount)"
	}
	
	func updateUserSex(_ sex: Sex) {
		if sex.rawValue == "남" {
			userGender = .male
			maleButton.rx.isSelected.onNext(true)
			femaleButton.rx.isSelected.onNext(false)
		} else {
			userGender = .female
			femaleButton.rx.isSelected.onNext(true)
			maleButton.rx.isSelected.onNext(false)
		}
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
		
		endEditingButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapEndEditingButton(
					name: owner.nickNameTextField.text,
					sex: owner.userGender
				)
			}
			.disposed(by: disposeBag)
	}
	
	// MARK: - UI Binding
	func bindForUI() {
		nickNameTextField.rx.text
			.orEmpty
			.withUnretained(self)
			.map { owner, text -> String in
				let maxCount = owner.maxTextCount
				return owner.trimmingSuffix(text, maxCount: maxCount)
			}
			.bind(to: nickNameTextField.textField.rx.text)
			.disposed(by: disposeBag)
		
		nickNameTextField.rx.text
			.orEmpty
			.withUnretained(self)
			.map { "\($1.count)/\($0.maxTextCount)" }
			.bind(to: maxTextCountLabel.rx.text)
			.disposed(by: disposeBag)
		
		calenderTextField.textField.rx.controlEvent(.editingDidBegin)
			.map { true }
			.bind(to: calenderTextField.textField.rx.isEditing)
			.disposed(by: disposeBag)
		
		calenderButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.calenderButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		maleButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.userGender = .male
				owner.maleButton.rx.isSelected.onNext(true)
				owner.femaleButton.rx.isSelected.onNext(false)
			}
			.disposed(by: disposeBag)
		
		femaleButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.userGender = .female
				owner.femaleButton.rx.isSelected.onNext(true)
				owner.maleButton.rx.isSelected.onNext(false)
			}
			.disposed(by: disposeBag)
	}
}

// MARK: - UI Logic
private extension UserProfileEditViewController {
	func trimmingSuffix(_ text: String, maxCount: Int) -> String {
		if text.count >= maxCount {
			let index = text.index(text.startIndex, offsetBy: maxCount)
			return String(text[..<index])
		}
		return text
	}
	
	func calenderButtonDidTap() {
		print("calenderButtonDidTap")
	}
}
