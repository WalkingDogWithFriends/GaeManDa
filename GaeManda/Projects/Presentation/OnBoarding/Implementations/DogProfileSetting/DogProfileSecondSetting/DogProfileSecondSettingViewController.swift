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
	func didTapConfirmButton()
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
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .jalnan20
		label.numberOfLines = 0
		label.text = "우리 아이를 등록해주세요! (2/2)"
		
		return label
	}()
	
	private let profileImageView = ProfileImageView(mode: .unEditable)
	private let confirmButton = ConfirmButton(title: "확인", isPositive: false)
	
	private let contentStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.spacing = 32
		stackView.axis = .vertical
		stackView.distribution = .fillProportionally
		stackView.alignment = .fill
		
		return stackView
	}()
	
	// MARK: - Life Cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		
		listener?.viewDidLoad()
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
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)

		self.view.endEditing(true)
	}
	
	// MARK: - UI Methods
	private func setupUI() {
		setViewHierarchy()
		setConstraints()
		bind()
	}
	
	override func setViewHierarchy() {
		super.setViewHierarchy()
		contentView.addSubviews(navigationBar, titleLabel, profileImageView, contentStackView, confirmButton)
	}
	
	override func setConstraints() {
		super.setConstraints()
		navigationBar.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
			make.height.equalTo(44)
		}
		
		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(navigationBar.snp.bottom).offset(28)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
		}
		
		profileImageView.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(40)
			make.width.height.equalTo(140)
			make.centerX.equalToSuperview()
		}
		
		contentStackView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(32)
			make.top.equalTo(profileImageView.snp.bottom).offset(56)
			make.bottom.equalTo(confirmButton.snp.top).offset(-60)
		}
		
		confirmButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.bottom.equalToSuperview().offset(-(54 - UIDevice.safeAreaBottomHeight))
			make.height.equalTo(40)
		}
	}
	
	func addDashboard(_ viewControllable: ViewControllable) {
		let viewController = viewControllable.uiviewController
		
		addChild(viewController)
		contentStackView.addArrangedSubviews(viewController.view)
		
		viewController.didMove(toParent: self)
	}

  // MARK: - UI Binding
	override func bind() {
		super.bind()
		bindNavigationBar()
		bindConfirmButton()
	}
	
	private func bindNavigationBar() {
		navigationBar.backButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapBackButton()
			}
			.disposed(by: disposeBag)
	}
	
  private func bindConfirmButton() { 
		confirmButton.rx.tap
			.withUnretained(self)
			.filter { owner, _ in
				owner.confirmButton.isPositive
			}
			.bind(with: self) { owner, _ in
				owner.listener?.didTapConfirmButton()
			}
			.disposed(by: disposeBag)
	}
}

// MARK: - Presentable
extension DogProfileSecondSettingViewController: DogProfileSecondSettingPresentable {
	func setConfirmButton(isPositive: Bool) {
		confirmButton.isPositive = isPositive
	}
	
	func updateProfileImage(with profileImage: UIImageWrapper) {
		guard let profileImage = profileImage.image else { return }
		
		profileImageView.image = selectedProfileImage
	}
}