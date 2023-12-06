import UIKit
import PhotosUI
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import Entity
import GMDExtensions
import GMDUtils
import OnBoarding

// swiftlint:disable:next type_name
protocol DogProfileSecondSettingPresentableListener: AnyObject {
	func viewDidLoad()
	func didTapConfirmButton(with passingModel: DogProfileSecondSettingPassingModel)
	func didTapBackButton()
	func dismiss()
}

final class DogProfileSecondSettingViewController:
	BaseViewController,
	DogProfileSecondSettingViewControllable {
	// MARK: - Properties
	weak var listener: DogProfileSecondSettingPresentableListener?
	var dropDownViews: [DropDownView]?
	
	private var selectedProfileImage: UIImage?
	private var selectedSpecies: String = ""
	private var isSelectedCharacters = BehaviorRelay<Bool>(value: false)
	
	// MARK: - UI Components
	private let navigationBar = GMDNavigationBar(title: "")
	private let onBoardingView = OnBoardingView(viewMode: .unEditableImageView, title: "우리 아이를 등록해주세요! (2/2)")
	
	private let dogSpeciesDropDownButton = DropDownButton(text: "우리 아이 종", mode: .title)
	private let dogSpeciesDropDownView = DropDownView()
	
	private let buttonStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 26
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	private let didNeuterButton = GMDOptionButton(title: "중성화 했어요", isSelected: true)
	private let didNotNeuterButton = GMDOptionButton(title: "중성화 안 했어요")
	
	private let confirmButton = ConfirmButton(title: "확인", isPositive: false)
	
	// MARK: - Life Cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		registerDropDrownViews(dogSpeciesDropDownView)
		
		listener?.viewDidLoad()
		
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
		setViewHierarchy()
		setConstraints()
		setDropDown()
		bind()
	}
	
	override func setViewHierarchy() {
		super.setViewHierarchy()
		contentView.addSubviews(
			navigationBar,
			onBoardingView,
			dogSpeciesDropDownButton,
			buttonStackView,
			confirmButton
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
		
		dogSpeciesDropDownButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.top.equalTo(onBoardingView.snp.bottom).offset(56)
		}
		
		dogSpeciesDropDownView.setConstraints { [weak self] make in
			guard let self else { return }
			make.leading.trailing.equalTo(self.dogSpeciesDropDownButton)
			make.top.equalTo(self.dogSpeciesDropDownButton.snp.bottom)
		}
		
		buttonStackView.snp.makeConstraints { make in
			make.top.equalTo(dogSpeciesDropDownButton.snp.bottom).offset(32)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.height.equalTo(40)
		}
		
		confirmButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.bottom.equalToSuperview().offset(-(54 - UIDevice.safeAreaBottomHeight))
			make.height.equalTo(40)
		}
	}
	
	func addDogCharacterDashboard(_ viewControllable: ViewControllable) {
		let viewController = viewControllable.uiviewController
		
		addChild(viewController)
		view.addSubview(viewController.view)
		
		viewController.view.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.top.equalTo(buttonStackView.snp.bottom).offset(32)
			make.bottom.equalTo(confirmButton.snp.top).offset(-120)
		}
		
		viewController.didMove(toParent: self)
	}
	
	private func setDropDown() {
		dogSpeciesDropDownView.anchorView = dogSpeciesDropDownButton
	}
	
	// MARK: - UI Binding
	override func bind() {
		super.bind()
		bindNavigationBar()
		bindDropDown()
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
	
	private func bindDropDown() {
		dogSpeciesDropDownView.rx.selectedOption
			.map { ($0, .option) }
			.bind(to: dogSpeciesDropDownButton.rx.title)
			.disposed(by: disposeBag)
	}
	
	private func bindButtons() {
		// 중성화 버튼 선택 Observable
		let selectedNeuteredObservable = Observable
			.merge(
				didNeuterButton.rx.tap.map { true },
				didNotNeuterButton.rx.tap.map { false }
			)
			.asDriver(onErrorJustReturn: true)
		
		// 선택된 성별이 남성일 경우
		selectedNeuteredObservable
			.map { $0 == true }
			.drive(didNeuterButton.rx.isSelected)
			.disposed(by: disposeBag)
		
		// 선택된 성별이 여성일 경우
		selectedNeuteredObservable
			.map { $0 == false }
			.drive(didNotNeuterButton.rx.isSelected)
			.disposed(by: disposeBag)
	}
	
	private func bindConfirmButton() {
		let dropDownSelectedObservable = Observable.combineLatest(
			dogSpeciesDropDownView.rx.isSelectedOption,
			isSelectedCharacters
		)
			.asDriver(onErrorJustReturn: (false, false))
		
		dropDownSelectedObservable
			.map { $0 && $1 }
			.drive(confirmButton.rx.isPositive)
			.disposed(by: disposeBag)
		
		confirmButton.rx.tap
			.withLatestFrom(dropDownSelectedObservable)
			.map { $0 && $1 }
			.filter { $0 == true }
			.bind(with: self) { owner, _ in
				let isNeutered = owner.didNeuterButton.isSelected ? true : false
				
				owner.listener?.didTapConfirmButton(
					with: DogProfileSecondSettingPassingModel(
						species: owner.selectedSpecies,
						isNeutered: isNeutered,
						characterIds: [0, 1],
						profileImage: .init(owner.selectedProfileImage)
					)
				)
			}
			.disposed(by: disposeBag)
	}
}

// MARK: - Presentable
extension DogProfileSecondSettingViewController: DogProfileSecondSettingPresentable {
	func isSelectedDogCharacter(_ isSelected: Bool) {
		isSelectedCharacters.accept(isSelected)
	}
	
	func updateDogSpecies(with dogSpecies: [String]) {
		dogSpeciesDropDownView.dataSource = dogSpecies
	}
	
	func updateProfileImage(with profileImage: UIImageWrapper) {
		guard let profileImage = profileImage.image else { return }
		
		selectedProfileImage = profileImage
		onBoardingView.setProfileImage(selectedProfileImage)
	}
}

// MARK: - DropDownListener
extension DogProfileSecondSettingViewController: DropDownListener {
	func dropdown(_ dropDown: DropDownView, didSelectRowAt indexPath: IndexPath) {
		selectedSpecies = dropDown.dataSource[indexPath.row]
	}
}
