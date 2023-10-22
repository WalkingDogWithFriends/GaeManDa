import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import Entity
import GMDUtils

protocol SecondDogSettingPresentableListener: AnyObject {
	func didTapConfirmButton()
	func didTapBackButton()
	func dismiss()
}

final class SecondDogSettingViewController:
	BaseViewController,
	SecondDogSettingPresentable,
	SecondDogSettingViewControllable {
	// MARK: - Properties
	weak var listener: SecondDogSettingPresentableListener?
	var dropDownViews: [DropDownView]?
	
	private let viewModel = SecondDogSettingViewModel()
	
	// MARK: - UI Components
	private let navigationBar = GMDNavigationBar(title: "")
	private let onBoardingView = OnBoardingView(willDisplayImageView: true, title: "우리 아이를 등록해주세요! (2/2)")
	
	private let dogBreedDropDownView = DropDownView(title: "우리 아이 종")
	private let dogCharacterDropDownView = DropDownView(title: "우리 아이 성격")
	
	private let buttonStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 26
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	private let didNeuterButton = GMDOptionButton(title: "했어요")
	private let didNotNeuterButton = GMDOptionButton(title: "안 했어요")
	private let confirmButton = ConfirmButton(title: "확인")
	
	// MARK: - Life Cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		registerDropDrownViews(dogBreedDropDownView, dogCharacterDropDownView)
		
		dogBreedDropDownView.dataSource = viewModel.dogBreedDataSource
		dogCharacterDropDownView.dataSource = viewModel.dogCharacterDataSource
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
	
	// MARK: - touchesBegan
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		guard
				let touch = touches.first,
				let hitView = self.view.hitTest(touch.location(in: view), with: event)
			else { return }
			self.hit(at: hitView)
	}
	
	// MARK: - UI Methods
	private func setupUI() {
		didNeuterButton.isSelected = true

		setViewHierarchy()
		setConstraints()
		bind()
	}
	
	override func setViewHierarchy() {
		super.setViewHierarchy()
		contentView.addSubviews(
			navigationBar, onBoardingView, dogBreedDropDownView, dogCharacterDropDownView, buttonStackView, confirmButton
		)
		buttonStackView.addArrangedSubviews(didNeuterButton, didNotNeuterButton)
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
		
		dogBreedDropDownView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(28)
			make.top.equalTo(onBoardingView.snp.bottom).offset(56)
			make.width.equalTo(216)
		}
		
		dogCharacterDropDownView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(28)
			make.top.equalTo(dogBreedDropDownView.snp.bottom).offset(48)
			make.width.equalTo(300)
		}
		
		buttonStackView.snp.makeConstraints { make in
			make.top.equalTo(dogCharacterDropDownView.snp.bottom).offset(52)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.height.equalTo(40)
		}
				
		confirmButton.snp.makeConstraints { make in
			make.top.equalTo(buttonStackView.snp.bottom).offset(108)
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
		bindButtons()
		bindConfirmButton()
	}
	
	private func bindNavigationBar() {
		navigationBar.backButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapBackButton()
			}
			.disposed(by: disposeBag)
	}
	
	private func bindButtons() {
		// 중성화 버튼 선택 Observable
		let selectedNeuterObservable = Observable
			.merge(
				didNeuterButton.rx.tap.map { Neutered.true },
				didNotNeuterButton.rx.tap.map { Neutered.false }
			)
			.asDriver(onErrorJustReturn: .true)
		
		// `중성화 했어요`를 선태한 경우
		selectedNeuterObservable
			.map { $0 == .true }
			.drive(didNeuterButton.rx.isSelected)
			.disposed(by: disposeBag)
		
		// `중성화 안했어요`를 선택한 경우
		selectedNeuterObservable
			.map { $0 == .false }
			.drive(didNotNeuterButton.rx.isSelected)
			.disposed(by: disposeBag)
	}
	
	private func bindConfirmButton() {
		// 드롭다운 선택 Observable
		let dropDownSelectedOptionObservable = Observable
			.combineLatest(
				dogBreedDropDownView.selectedOptionRelay,
				dogCharacterDropDownView.selectedOptionRelay
			)
			.map { (($0.0 != nil), ($0.1 != nil) ) }
			.asDriver(onErrorJustReturn: (false, false))
	
		dropDownSelectedOptionObservable
			.map { $0.0 && $0.1 }
			.drive(confirmButton.rx.isPositive)
			.disposed(by: disposeBag)
		
		confirmButton.rx.tap
			.withLatestFrom(dropDownSelectedOptionObservable)
			.map { $0.0 && $0.1 }
			.filter { $0 == true }
			.bind(with: self) { owner, _ in
				owner.listener?.didTapConfirmButton()
			}
			.disposed(by: disposeBag)
	}
}

// MARK: - DropDownListener
extension SecondDogSettingViewController: DropDownListener {	
	func dropdown(_ dropDown: DropDownView, didSelectRowAt indexPath: IndexPath) { }
}
