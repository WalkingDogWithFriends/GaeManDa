import PhotosUI
import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import Entity
import GMDUtils
import GMDExtensions
import OnBoarding

// swiftlint:disable:next type_name
protocol DogProfileFirstSettingPresentableListener: AnyObject {
	func didTapConfirmButton(with passingModel: DogProfileFirstSettingPassingModel)
	func didTapBackButton()
	func didTapBirthdayPicker()
	func dismiss()
}

final class DogProfileFirstSettingViewController:
	BaseViewController,
	DogProfileFirstSettingViewControllable {
	// MARK: - Constants
	private let kgSuffix = "kg"
	private let maximumTextCount = 20
	
	// MARK: - Properties
	weak var listener: DogProfileFirstSettingPresentableListener?
	var textDidChangeNotification: NSObjectProtocol?
	
	var selectedProfileImage: UIImage?
	
	// MARK: - UI Components
	private let navigationBar = GMDNavigationBar(title: "")
	
	private let onBoardingView = OnBoardingView(viewMode: .editableImageView, title: "우리 아이를 등록해주세요! (1/2)")
	
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
	
	private let dogNameTextField = GMDTextField(title: "우리 아이 이름", warningText: "우리 아이 이름을 작성해주세요")
	
	private let maximumTextCountLabel = UILabel()
	
	private let calenderTextField = GMDTextField(title: "우리 아이 생년월일", warningText: "생년월일을 입력해주세요.")
	
	private let calenderButton: UIButton = {
		let button = UIButton()
		button.tintColor = .black
		button.setImage(.iconCalendar, for: .normal)
		
		return button
	}()
	
	private let dogWeightTextField: GMDTextField = {
		let gmdTextField = GMDTextField(
			title: "우리 아이 몸무게 (kg)",
			warningText: "우리 아이 몸무게 (kg)을 입력해주세요."
		)
		gmdTextField.textField.keyboardType = .numberPad
		
		return gmdTextField
	}()
	
	private let maleButton = GMDOptionButton(title: "남", isSelected: true)
	private let femaleButton = GMDOptionButton(title: "여")
	private let confirmButton = ConfirmButton(title: "확인", isPositive: false)
	
	// MARK: - Life Cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		
		textDidChangeNotification = registerTextFieldNotification()
		setupUI()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		removeTextFieldNotification([textDidChangeNotification])
		
		if isBeingDismissed || isMovingFromParent {
			listener?.dismiss()
		}
	}
	
	// MARK: - UI Methods
	private func setupUI() {
		dogNameTextField.setRightView(maximumTextCountLabel)
		calenderTextField.setRightView(calenderButton)
		
		setViewHierarchy()
		setConstraints()
		bind()
	}
	
	override func setViewHierarchy() {
		super.setViewHierarchy()
		contentView.addSubviews(navigationBar, onBoardingView, textStackView, buttonStackView, confirmButton)
		
		textStackView.addArrangedSubviews(dogNameTextField, calenderTextField, dogWeightTextField)
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
		
		textStackView.snp.makeConstraints { make in
			make.top.equalTo(onBoardingView.snp.bottom).offset(24)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
		}
		
		buttonStackView.snp.makeConstraints { make in
			make.top.equalTo(textStackView.snp.bottom).offset(28)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.height.equalTo(40)
		}
		
		confirmButton.snp.makeConstraints { make in
			make.top.equalTo(buttonStackView.snp.bottom).offset(58)
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
		bindOnboardingView()
		bindTextField()
		bindButtons()
		bindConfirmButton()
	}
	
	private func bindNavigation() {
		navigationBar.backButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapBackButton()
			}
			.disposed(by: disposeBag)
	}
	
	private func bindOnboardingView() {
		onBoardingView.rx.didTapImageView
			.bind(with: self) { owner, _ in
				owner.presentPHPickerView()
			}
			.disposed(by: disposeBag)
	}
	
	private func bindTextField() {
		dogNameTextField.textField.rx.text
			.orEmpty
			.withUnretained(self)
			.map { owner, text in
				return text.trimmingSuffix(with: owner.maximumTextCount)
			}
			.bind(with: self) { owner, text in
				owner.dogNameTextField.textField.attributedText = text.inputText()
				owner.maximumTextCountLabel.attributedText =
				"\(text.count)/\(owner.maximumTextCount)".inputText(color: .gray90)
			}
			.disposed(by: disposeBag)
		
		dogNameTextField.textField.rx.text
			.orEmpty
			.map { _ in GMDTextFieldMode.normal }
			.bind(to: dogNameTextField.rx.mode)
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
				owner.listener?.didTapBirthdayPicker()
			}
			.disposed(by: disposeBag)
		
		// 성별 버튼 선택 Observable
		let selectedSexObservable = Observable
			.merge(
				maleButton.rx.tap.map { Gender.male },
				femaleButton.rx.tap.map { Gender.female }
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
	}
	
	func bindConfirmButton() {
		// 닉네임, 생일, 몸무게 입력 여부 Observable
		let textFieldsTextEmptyObservable = Observable
			.combineLatest(
				dogNameTextField.rx.text.orEmpty,
				calenderTextField.rx.text.orEmpty,
				dogWeightTextField.rx.text.orEmpty
			)
			.map { (!$0.0.isEmpty, !$0.1.isEmpty, !$0.2.isEmpty) }
			.asDriver(onErrorJustReturn: (false, false, false))
		
		// Confirm버튼 활성화
		textFieldsTextEmptyObservable
			.map { $0 && $1 && $2 }
			.drive(confirmButton.rx.isPositive)
			.disposed(by: disposeBag)
		
		// 닉네임, 생일, 몸무게가 모두 입력되었을 경우
		confirmButton.rx.tap
			.withLatestFrom(textFieldsTextEmptyObservable)
			.map { $0 && $1 && $2 }
			.filter { $0 == true }
			.bind(with: self) { owner, _ in
				let gender: Gender = owner.maleButton.isSelected ? .male : .female
				
				owner.listener?.didTapConfirmButton(
					with: DogProfileFirstSettingPassingModel(
						name: owner.dogNameTextField.text,
						birthday: owner.calenderTextField.text.trimmingCharacters(in: ["."]), 
						gender: gender,
						weight: Int(owner.dogWeightTextField.text) ?? 0,
						profileImage: .init(owner.selectedProfileImage)
					)
				)
			}
			.disposed(by: disposeBag)
		
		// 닉네임, 생일이 입력되지 않은 경우
		confirmButton.rx.tap
			.withLatestFrom(textFieldsTextEmptyObservable)
			.bind(with: self) { owner, isEmpty in
				owner.dogNameTextField.mode = isEmpty.0 ? .normal : .warning
				owner.calenderTextField.mode = isEmpty.1 ? .normal : .warning
				owner.dogWeightTextField.mode = isEmpty.2 ? .normal : .warning
			}
			.disposed(by: disposeBag)
	}
}

// MARK: - GMDTextFieldListener
extension DogProfileFirstSettingViewController: GMDTextFieldListener {}

// MARK: - PHPickerViewControllerDelegate
extension DogProfileFirstSettingViewController: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		picker.dismiss(animated: true)
		guard let firstResult = results.first else { return }
		firstResult.fetchImage { result in
			switch result {
				case let .success(image):
					self.onBoardingView.setProfileImage(image)
					self.selectedProfileImage = image
				case .failure: break //
			}
		}
	}
}

extension DogProfileFirstSettingViewController: DogProfileFirstSettingPresentable {
	func setBirthday(date: String) {
		self.calenderTextField.text = date
	}
}
