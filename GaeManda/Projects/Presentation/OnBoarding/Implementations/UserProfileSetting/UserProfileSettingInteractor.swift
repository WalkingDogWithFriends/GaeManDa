import RIBs
=import OnBoarding

protocol UserProfileSettingRouting: ViewableRouting {
	func attachBirthdayPicker()
	func detachBirthdayPicker()
}

protocol UserProfileSettingPresentable: Presentable {
	var listener: UserProfileSettingPresentableListener? { get set }
	
	func displayBirthday(date: String)
}

final class UserProfileSettingInteractor:
	PresentableInteractor<UserProfileSettingPresentable>,
	UserProfileSettingInteractable,
	UserProfileSettingPresentableListener {
	func birthdaySelected(date: String) {
		presenter.displayBirthday(date: date)
		router?.detachBirthdayPicker()
	}
	
	weak var router: UserProfileSettingRouting?
	weak var listener: UserProfileSettingListener?
	
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
