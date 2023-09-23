import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import Entity
import GMDExtensions
import GMDUtils

protocol UserSettingPresentableListener: AnyObject {
	func confirmButtonDidTap()
	func backButtonDidTap()
}

final class UserSettingViewController:
	BaseViewController,
	UserSettingPresentable,
	UserSettingViewControllable {
	// MARK: - Properties
	weak var listener: UserSettingPresentableListener?
	
	private let maximumTextCount = 20
	
	// MARK: - UI Components
	private let navigationBar = GMDNavigationBar(title: "")
	
	private let onBoardingView = OnBoardingView(willDisplayImageView: true, title: "보호자의 프로필을 설정해주세요!")
	
	private let nickNameTextField = GMDTextField(title: "닉네임", warningText: "닉네임을 입력해주세요.")
	
	private let maximumTextCountLabel = UILabel()
	
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
	
	private let maleButton: GMDOptionButton = {
		let button = GMDOptionButton(title: "남")
		button.isSelected = true
		
		return button
	}()
	
	private let femaleButton = GMDOptionButton(title: "여")
	
	private let confirmButton = ConfirmButton(title: "확인")
	
	// MARK: - Life Cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	// MARK: - UI Methods
	private func setupUI() {
		setTextField(nickNameTextField.textField, rightView: maximumTextCountLabel)
		setTextField(calenderTextField.textField, rightView: calenderButton)
		setViewHierarchy()
		setConstraints()
		bind()
	}
	
	func setTextField(_ textField: UITextField, rightView: UIView) {
		textField.rightView = rightView
		textField.rightViewMode = .always
	}
	
	override func setViewHierarchy() {
		super.setViewHierarchy()
		contentView.addSubviews(
			navigationBar, onBoardingView, nickNameTextField, calenderTextField, buttonStackView, confirmButton
		)
		buttonStackView.addArrangedSubviews(maleButton, femaleButton)
	}
	
	override func setConstraints() {
		super.setConstraints()
		navigationBar.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
			make.height.equalTo(44)
		}
		
		onBoardingView.snp.makeConstraints { make in
			make.top.equalTo(navigationBar.snp.bottom).offset(28)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
		}
		
		nickNameTextField.snp.makeConstraints { make in
			make.top.equalTo(onBoardingView.snp.bottom).offset(48)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
		}
		
		calenderTextField.snp.makeConstraints { make in
			make.top.equalTo(nickNameTextField.snp.bottom).offset(16)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
		}
		
		buttonStackView.snp.makeConstraints { make in
			make.top.equalTo(calenderTextField.snp.bottom).offset(44)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.height.equalTo(40)
		}
		
		confirmButton.snp.makeConstraints { make in
			make.top.equalTo(buttonStackView.snp.bottom).offset(98)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.bottom.equalToSuperview().offset(-(54 - UIDevice.safeAreaBottomHeight))
			make.height.equalTo(40)
		}
	}
	
	// MARK: - Bind Methods
	override func bind() {
		super.bind()
		bindNavigation()
		bindTextField()
		bindButtons()
	}
	
	private func bindNavigation() {
		navigationBar.backButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.backButtonDidTap()
			}
			.disposed(by: disposeBag)
	}
	
	private func bindTextField() {
		nickNameTextField.textField.rx.text
			.orEmpty
			.withUnretained(self)
			.map { owner, text in
				return text.trimmingSuffix(with: owner.maximumTextCount)
			}
			.bind(with: self) { owner, text in
				owner.nickNameTextField.textField.attributedText = text.inputText()
				owner.maximumTextCountLabel.attributedText =
				"\(text.count)/\(owner.maximumTextCount)".inputText(color: .gray90)
			}
			.disposed(by: disposeBag)
		
		nickNameTextField.textField.rx.text
			.orEmpty
			.map { _ in GMDTextFieldMode.normal }
			.bind(to: nickNameTextField.rx.mode)
			.disposed(by: disposeBag)
		
		calenderTextField.textField.rx.controlEvent(.editingDidBegin)
			.bind(with: self) { owner, _ in
				owner.calenderTextField.textField.endEditing(true)
			}
			.disposed(by: disposeBag)
	}
	
	private func bindButtons() {
		calenderButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.calenderButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		// 성별 버튼 선택 Observable
		let selectedSexObservable = Observable
			.merge(
				maleButton.rx.tap.map { Sex.male },
				femaleButton.rx.tap.map { Sex.female }
			)
			.asDriver(onErrorJustReturn: .male)
		
		// 선택된 성별이 남성일 경우
		selectedSexObservable
			.map { $0 == .male }
			.drive(maleButton.rx.isSelected)
			.disposed(by: disposeBag)
		
		// 선택된 성별이 여성일 경우
		selectedSexObservable
			.map { $0 == .female }
			.drive(femaleButton.rx.isSelected)
			.disposed(by: disposeBag)
		
		// 닉네임, 생일 입력 여부 Observable
		let textFieldsTextEmptyObservable = Observable
			.combineLatest(
				nickNameTextField.textField.rx.text.orEmpty,
				calenderTextField.textField.rx.text.orEmpty
			)
			.map { (!$0.0.isEmpty, !$0.1.isEmpty) }
			.asDriver(onErrorJustReturn: (false, false))
		
		// 닉네임, 생일이 모두 입력되었을 경우
		confirmButton.rx.tap
			.withLatestFrom(textFieldsTextEmptyObservable)
			.map { $0 && $1 }
			.filter { $0 == true }
			.bind(with: self) { owner, _ in
				owner.listener?.confirmButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		// 닉네임, 생일이 입력되지 않은 경우
		confirmButton.rx.tap
			.withLatestFrom(textFieldsTextEmptyObservable)
			.bind(with: self) { owner, isEmpty in
				owner.nickNameTextField.mode = isEmpty.0 ? .normal : .warning
				owner.calenderTextField.mode = isEmpty.1 ? .normal : .warning
			}
			.disposed(by: disposeBag)
	}
}

// MARK: - Action
private extension UserSettingViewController {
	func calenderButtonDidTap() {
		print("calenderButtonDidTap")
	}
}
