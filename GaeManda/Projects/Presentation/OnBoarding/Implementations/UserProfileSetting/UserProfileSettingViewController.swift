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
	UserProfileSettingViewControllable {
	// MARK: - Properties
	weak var listener: UserProfileSettingPresentableListener?
	
	private var selectedProfileImage: UIImage?
	
	// MARK: - UI Components
	private let navigationBar = GMDNavigationBar(title: "")
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .jalnan20
		label.numberOfLines = 0
		label.text = "보호자의 프로필을 설정해주세요!"
		
		return label
	}()
	
	private let profileImageView = ProfileImageView(mode: .editable)
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
		contentView.addSubviews(navigationBar, titleLabel, profileImageView, confirmButton)
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
			make.top.equalTo(profileImageView.snp.bottom).offset(48)
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
		profileImageView.rx.didTapImageView
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

// MARK: - UserProfileSettingPresentable
extension UserProfileSettingViewController: UserProfileSettingPresentable {
	func setConfirmButton(isEnabled: Bool) {
		confirmButton.isPositive = isEnabled
	}
}

// MARK: - PHPickerViewControllerDelegate
extension UserProfileSettingViewController: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		picker.dismiss(animated: true)
		guard let firstResult = results.first else { return }
		firstResult.fetchImage { result in
			switch result {
				case let .success(image):
					self.profileImageView.image = image
					self.selectedProfileImage = image
				case .failure: break //
			}
		}
	}
}
