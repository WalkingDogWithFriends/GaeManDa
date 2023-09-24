import UIKit
import RIBs
import RxCocoa
import RxSwift
import RxGesture
import SnapKit
import DesignKit
import GMDExtensions
import GMDUtils

protocol SecondDogSettingPresentableListener: AnyObject {
	func confirmButtonDidTap()
	func backButtonDidTap()
	func dismiss()
}

final class SecondDogSettingViewController:
	BaseViewController,
	SecondDogSettingPresentable,
	SecondDogSettingViewControllable, UITextFieldDelegate {
	// MARK: - Properties
	weak var listener: SecondDogSettingPresentableListener?
	private let kgSuffix = "kg"
	
	// MARK: - UI Components
	private let navigationBar = GMDNavigationBar(title: "")
	
	private let onBoardingView = OnBoardingView(willDisplayImageView: true, title: "우리 아이를 등록해주세요! (2/3)")
	
	private let dogBreedTextField = GMDTextField(title: "우리 아이 종", warningText: "우리 아이 종을 작성해주세요")
	
	private let dogWeightTextField: GMDTextField = {
		let gmdTextField = GMDTextField(
			title: "우리 아이 몸무게 (kg)",
			warningText: "우리 아이 몸무게 (kg)을 입력해주세요."
		)
		gmdTextField.textField.keyboardType = .numberPad
		
		return gmdTextField
	}()
	
	private let confirmButton = ConfirmButton(title: "확인")
	
	// MARK: - Life Cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		if isBeingDismissed || isMovingFromParent {
			listener?.dismiss()
		}
	}
	
	// MARK: - UI Methods
	private func setupUI() {
		setViewHierarchy()
		setConstraints()
		bind()
	}
	
	override func setViewHierarchy() {
		super.setViewHierarchy()
		contentView.addSubviews(
			navigationBar, onBoardingView, dogBreedTextField, dogWeightTextField, confirmButton
		)
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
		
		dogBreedTextField.snp.makeConstraints { make in
			make.top.equalTo(onBoardingView.snp.bottom).offset(48)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
		}
		
		dogWeightTextField.snp.makeConstraints { make in
			make.top.equalTo(dogBreedTextField.snp.bottom).offset(16)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
		}
		
		confirmButton.snp.makeConstraints { make in
			make.top.equalTo(dogWeightTextField.snp.bottom).offset(182)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.bottom.equalToSuperview().offset(-(54 - UIDevice.safeAreaBottomHeight))
			make.height.equalTo(40)
		}
	}
	
	// MARK: - UI Binding
	override func bind() {
		super.bind()
		bindNavigationBar()
		bindTextField()
		bindConfirmButton()
	}
	
	private func bindNavigationBar() {
		navigationBar.backButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.backButtonDidTap()
			}
			.disposed(by: disposeBag)
	}
		
	private func bindTextField() {
		dogWeightTextField.textField.rx.text
			.orEmpty
			.filter { !$0.isEmpty }
			.map { $0.append(suffix: "kg") }
			.bind(to: dogWeightTextField.textField.rx.text)
			.disposed(by: disposeBag)
		
		let cursorObservable = Observable.merge([
			dogWeightTextField.textField.rx.tapGesture().when(.recognized).map { _ in () },
			dogWeightTextField.textField.rx.controlEvent(.allEditingEvents).asObservable()
		])
		
		// suffix부분에 커서가 이동이 안되도록 해줌.
		cursorObservable
			.bind(with: self) { owner, _ in
				owner.dogWeightTextField.textField.moveCusorLeftTo(suffix: "kg")
			}
			.disposed(by: disposeBag)
	}
	
	private func bindConfirmButton() {
		let textFieldsTextEmptyObservable = Observable
			.combineLatest(
				dogBreedTextField.rx.text.orEmpty,
				dogWeightTextField.rx.text.orEmpty
			)
			.map { (!$0.0.isEmpty, !$0.1.isEmpty) }
			.asDriver(onErrorJustReturn: (false, false))
		
		// 품종, 몸무게가 모두 입력된 경우
		confirmButton.rx.tap
			.withLatestFrom(textFieldsTextEmptyObservable)
			.filter { $0 == true && $1 == true }
			.bind(with: self) { owner, _ in
				owner.listener?.confirmButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		// 품종, 몸무게가 입력되지 않은 경우
		confirmButton.rx.tap
			.withLatestFrom(textFieldsTextEmptyObservable)
			.bind(with: self) { owner, isEmpty in
				owner.dogBreedTextField.mode = isEmpty.0 ? .normal : .warning
				owner.dogWeightTextField.mode = isEmpty.1 ? .normal : .warning
			}
			.disposed(by: disposeBag)
	}
}
