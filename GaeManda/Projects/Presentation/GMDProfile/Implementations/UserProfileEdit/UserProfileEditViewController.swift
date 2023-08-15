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
import GMDExtensions
import GMDUtils

protocol UserProfileEditPresentableListener: AnyObject {
	func backbuttonDidTap()
	func endEditingButtonDidTap()
}

final class UserProfileEditViewController:
	UIViewController,
	UserProfileEditPresentable,
	UserProfileEditViewControllable {
	weak var listener: UserProfileEditPresentableListener?
	private let disposeBag = DisposeBag()
	
	// MARK: UI Property
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
	
	private let nickNameTextField: GMDTextField = {
		let gmdTextField = GMDTextField(
			title: "닉네임",
			warningText: "닉네임을 입력해주세요."
		)
		
		return gmdTextField
	}()
	
	private var maximumTextCount = 20
	
	/// Display Max Count Text in nickNameTextField
	private lazy var maximumTextCountLabel: UILabel = {
		let label = UILabel()
		label.textColor = .gray90
		label.font = .r15
		
		return label
	}()
	
	private let calenderTextField: GMDTextField = {
		let gmdTextField = GMDTextField(
			title: "생년월일",
			warningText: "생년월일을 입력해주세요."
		)
		
		return gmdTextField
	}()
	
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
	
	private let maleButton: GMDOptionButton = {
		let button = GMDOptionButton(title: "남")
		button.isSelected = true
		
		return button
	}()
	
	private let femaleButton: GMDOptionButton = {
		let button = GMDOptionButton(title: "여")
		
		return button
	}()
	
	private let endEditingButton: UIButton = {
		let button = UIButton()
		button.setTitle("수정 완료", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.layer.cornerRadius = 4
		button.backgroundColor = .green100
		button.titleLabel?.font = .b16
		
		return button
	}()
	
	// MARK: Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		hideTabBar()
	}
}

// MARK: Setting UI
private extension UserProfileEditViewController {
	func setupUI() {
		view.backgroundColor = .white
		self.setupBackNavigationButton(
			target: self,
			action: #selector(backbuttonDidTap)
		)
		
		title = "프로필 수정"
		setNavigationTitleFont(.b20)
		
		/// Set TextField Right View
		nickNameTextField.textField.rightView = maximumTextCountLabel
		nickNameTextField.textField.rightViewMode = .always
		
		calenderTextField.textField.rightView = calenderButton
		calenderTextField.textField.rightViewMode = .always
		
		setupSubviews()
		setConstraints()
		bind()
	}
	
	func setupSubviews() {
		view.addSubview(profileImageView)
		view.addSubview(textStackView)
		view.addSubview(buttonStackView)
		view.addSubview(endEditingButton)
		
		textStackView.addArrangedSubview(nickNameTextField)
		textStackView.addArrangedSubview(calenderTextField)
		
		buttonStackView.addArrangedSubview(maleButton)
		buttonStackView.addArrangedSubview(femaleButton)
	}
	
	func setConstraints() {
		profileImageView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(186)
			make.centerX.equalToSuperview()
			make.height.width.equalTo(140)
		}
		
		textStackView.snp.makeConstraints { make in
			make.top.equalTo(profileImageView.snp.bottom).offset(58)
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

// MARK: Bind
private extension UserProfileEditViewController {
	func bind() {
		nickNameTextField.textField.rx.text
			.orEmpty
			.withUnretained(self)
			.bind { owner, text in
				owner.setTextCountLabel(text)
			}
			.disposed(by: disposeBag)
		
		calenderTextField.textField.rx.controlEvent(.editingDidBegin)
			.withUnretained(self)
			.bind { owner, _ in
				owner.calenderTextField.textField.endEditing(true)
			}
			.disposed(by: disposeBag)
		
		calenderButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.calenderButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		maleButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.maleButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		femaleButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.femaleButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		endEditingButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.listener?.endEditingButtonDidTap()
			}
			.disposed(by: disposeBag)
	}
}

// MARK: Action
private extension UserProfileEditViewController {
	@objc func backbuttonDidTap() {
		listener?.backbuttonDidTap()
	}
	
	func setTextCountLabel(_ text: String) {
		var newText = text
		
		if text.count >= maximumTextCount {
			let index = text.index(text.startIndex, offsetBy: maximumTextCount)
			newText = String(text[..<index])
			nickNameTextField.textField.text = newText
		}
		maximumTextCountLabel.text = "\(newText.count)/\(maximumTextCount)"
	}
	
	func calenderButtonDidTap() {
		print("calenderButtonDidTap")
	}
	
	func maleButtonDidTap() {
		if maleButton.isSelected == true { return }
		
		maleButton.isSelected = true
		femaleButton.isSelected = false
	}
	
	func femaleButtonDidTap() {
		if femaleButton.isSelected == true { return }
		
		femaleButton.isSelected = true
		maleButton.isSelected = false
	}
}
