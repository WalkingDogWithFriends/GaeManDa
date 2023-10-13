import RIBs
import OnBoarding

protocol UserSettingRouting: ViewableRouting {
	func attachBirthdayPicker()
	func detachBirthdayPicker()
}

protocol UserSettingPresentable: Presentable {
	var listener: UserSettingPresentableListener? { get set }
	
	func displayBirthday(date: String)
}

final class UserSettingInteractor:
	PresentableInteractor<UserSettingPresentable>,
	UserSettingInteractable,
	UserSettingPresentableListener {
	func birthdaySelected(date: String) {
		presenter.displayBirthday(date: date)
		router?.detachBirthdayPicker()
	}
	
	weak var router: UserSettingRouting?
	weak var listener: UserSettingListener?
	
	override init(presenter: UserSettingPresentable) {
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
extension UserSettingInteractor {
	func confirmButtonDidTap() {
		listener?.userSettingDidFinish()
	}
	
	func backButtonDidTap() {
		listener?.userSettingBackButtonDidTap()
	}
	
	func birthdayPickerDidTap() {
		router?.attachBirthdayPicker()
	}
	
	func dismiss() {
		listener?.userSettingDismiss()
	}
}

// MARK: - BirthdayPickerListener
extension UserSettingInteractor {
	func didTapBirthdayPicker() {
		router?.attachBirthdayPicker()
	}
	
	func birthdayPickerDismiss() {
		router?.detachBirthdayPicker()
	}
}
