import PhotosUI
import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import Entity
import GMDExtensions
import GMDUtils
import OnBoarding

protocol UserProfileSettingPresentableListener: AnyObject {
	func viewDidLoad()
	func confirmButtonDidTap(with profileImage: UIImageWrapper)
	func backButtonDidTap()
	func dismiss()
}

final class UserProfileSettingViewController:
	BaseViewController,
	UserProfileSettingPresentable,
	UserProfileSettingViewControllable {
	// MARK: - Properties
	weak var listener: UserProfileSettingPresentableListener?
	
	private var selectedProfileImage: UIImage?
	
	// MARK: - UI Components
	private let navigationBar = GMDNavigationBar(title: "")
	private let onBoardingView = OnBoardingView(viewMode: .editableImageView, title: "보호자의 프로필을 설정해주세요!")
	private let confirmButton = ConfirmButton(title: "확인", isPositive: false)
	
	// MARK: - Life Cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		listener?.viewDidLoad()
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
		contentView.addSubviews(navigationBar, onBoardingView, confirmButton)
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
		
		confirmButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.bottom.equalToSuperview().offset(-(54 - UIDevice.safeAreaBottomHeight))
			make.height.equalTo(40)
		}
	}
	
	func addUserProfileDashboard(_ viewControllable: ViewControllable) {
		let viewController = viewControllable.uiviewController
		
		addChild(viewController)
		contentView.addSubview(viewController.view)
		
		viewController.view.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.top.equalTo(onBoardingView.snp.bottom).offset(48)
			make.bottom.equalTo(confirmButton.snp.top).offset(-60)
		}
		
		viewController.didMove(toParent: self)
	}
	
	// MARK: - Bind Methods
	override func bind() {
		super.bind()
		bindNavigation()
		bindOnboardingView()
		bindConfirmButton()
	}
	
	private func bindNavigation() {
		navigationBar.backButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.backButtonDidTap()
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
	
	private func bindConfirmButton() {
		// 닉네임, 생일이 모두 입력되었을 경우
		confirmButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.confirmButtonDidTap(with: .init(owner.selectedProfileImage))
			}
			.disposed(by: disposeBag)
	}
}

extension UserProfileSettingViewController: PHPickerViewControllerDelegate {
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
