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
	
	private let onBoardingView = OnBoardingView(viewMode: .editableImageView, title: "보호자의 프로필을 설정해주세요!")
	
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
	
	private let maleButton = GMDOptionButton(title: "남", isSelected: true)
	private let femaleButton = GMDOptionButton(title: "여")
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
		
		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(navigationBar.snp.bottom).offset(28)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
		}
		
		nickNameTextField.snp.makeConstraints { make in
			make.top.equalTo(onBoardingView.snp.bottom).offset(48)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
		}
	}
	
	func addUserProfileDashboard(_ viewControllable: ViewControllable) {
		let viewController = viewControllable.uiviewController
		
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
	}
	
	func addUserProfileDashboard(_ viewControllable: ViewControllable) {
		let viewController = viewControllable.uiviewController
		
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

// MARK: - Presentable {
extension UserProfileSettingViewController {
	func displayBirthday(date: String) {
		self.calenderTextField.text = date
	}
}

// MARK: - Action
private extension UserProfileSettingViewController {
	func calenderButtonDidTap() {
		listener?.birthdayPickerDidTap()
	}
}

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
