import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import GMDExtensions
import GMDUtils

protocol SecondDogSettingPresentableListener: AnyObject {
	func confirmButtonDidTap()
	func backButtonDidTap()
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
		bindNavigation()
		bindTextField()
		bindConfirmButton()
	}
	
	private func bindNavigation() {
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
		
		dogWeightTextField.textField.rx.cursorChanged
			.bind(with: self) { owner, _ in
				owner.dogWeightTextField.textField.moveCusorLeftTo(suffix: "kg")
			}
			.disposed(by: disposeBag)
		
		let textFieldsTextEmptyObservable = Observable
			.combineLatest(
				dogBreedTextField.rx.text.orEmpty,
				dogWeightTextField.rx.text.orEmpty
			)
			.map { (!$0.0.isEmpty, !$0.1.isEmpty) }
			.asDriver(onErrorJustReturn: (false, false))
		
		confirmButton.rx.tap
			.withLatestFrom(textFieldsTextEmptyObservable)
			.map { $0 && $1 }
			.filter { $0 == true }
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
	
	private func bindConfirmButton() {
		confirmButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.confirmButtonDidTap()
			}
			.disposed(by: disposeBag)
	}
}
