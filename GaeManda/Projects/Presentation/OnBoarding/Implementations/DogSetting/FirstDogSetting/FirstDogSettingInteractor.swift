import RIBs

protocol FirstDogSettingRouting: ViewableRouting {
	func attachBirthdayPicker()
	func detachBirthdayPicker()
}

protocol FirstDogSettingPresentable: Presentable {
	var listener: FirstDogSettingPresentableListener? { get set }
	
	func setBirthday(date: String)
}

protocol FirstDogSettingListener: AnyObject {
	func firstDogSettingDidFinish()
	func firstDogSettingBackButtonDidTap()
	func firstDogSettingDismiss()
}

final class FirstDogSettingInteractor:
	PresentableInteractor<FirstDogSettingPresentable>,
	FirstDogSettingInteractable,
	FirstDogSettingPresentableListener {
	weak var router: FirstDogSettingRouting?
	weak var listener: FirstDogSettingListener?

	override init(presenter: FirstDogSettingPresentable) {
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

// MARK: PresentableListener
extension FirstDogSettingInteractor {
	func confirmButtonDidTap() {
		listener?.firstDogSettingDidFinish()
	}
	
	func backButtonDidTap() {
		listener?.firstDogSettingBackButtonDidTap()
	}
	
	func dismiss() {
		listener?.firstDogSettingDismiss()
	}
}

// MARK: - BirthdayPickerListener
extension FirstDogSettingInteractor {
	func didTapBirthdayPicker() {
		router?.attachBirthdayPicker()
	}
	
	func birthdayPickerDismiss() {
		router?.detachBirthdayPicker()
	}
	
	func birthdaySelected(date: String) {
		presenter.setBirthday(date: date)
		router?.detachBirthdayPicker()
	}
}
