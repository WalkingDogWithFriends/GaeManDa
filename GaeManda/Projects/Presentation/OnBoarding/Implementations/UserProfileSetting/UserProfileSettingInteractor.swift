import RIBs
import RxSwift
import RxRelay
import CorePresentation
import Entity
import OnBoarding
import GMDUtils

protocol UserProfileSettingRouting: ViewableRouting {
	func attachUserProfileDashboard(
		usernameTextFieldModeRelay: BehaviorRelay<NicknameTextFieldMode>,
		birthdayTextFieldIsWarningRelay: BehaviorRelay<Bool>
	)
}

protocol UserProfileSettingPresentable: Presentable {
	var listener: UserProfileSettingPresentableListener? { get set }
	
	func setConfirmButton(isEnabled: Bool)
}

final class UserProfileSettingInteractor:
	PresentableInteractor<UserProfileSettingPresentable>,
	UserProfileSettingInteractable,
	UserProfileSettingPresentableListener {
	weak var router: UserProfileSettingRouting?
	weak var listener: UserProfileSettingListener?
	
	private let userNameTextFieldMode = BehaviorRelay<NicknameTextFieldMode>(value: .default)
	private let birthdayTextFieldIsWarning = BehaviorRelay<Bool>(value: true)
	
	private var selectedGender: Gender = .male
	private var enteredUserName: String?
	private var selectedBirthday: String?
	
	override init(presenter: UserProfileSettingPresentable) {
		super.init(presenter: presenter)
		presenter.listener = self
	}
	
	override func didBecomeActive() {
		super.didBecomeActive()
	}
	
	override func willResignActive() {
		super.willResignActive()
	}
}

// MARK: - PresentableListener
extension UserProfileSettingInteractor {
	func confirmButtonDidTap(with passingModel: UserProfileSettingPassingModel) {
		listener?.userProfileSettingDidFinish(with: passingModel)
	}
	
	func confirmButtonDidTap() {
	}
	
	func backButtonDidTap() {
		listener?.userProfileSettingBackButtonDidTap()
	}
	
	func birthdayPickerDidTap() {
		router?.attachBirthdayPicker()
	}
	
	func dismiss() {
		listener?.userProfileSettingDismiss()
	}
}

// MARK: - BirthdayPickerListener
extension UserProfileSettingInteractor {
	func didTapBirthdayPicker() {
		router?.attachBirthdayPicker()
	}
	
	func birthdayPickerDismiss() {
		router?.detachBirthdayPicker()
	}
}
