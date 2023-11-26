import RIBs

protocol DogProfileFirstSettingRouting: ViewableRouting {
	func attachBirthdayPicker()
	func detachBirthdayPicker()
}

protocol DogProfileFirstSettingPresentable: Presentable {
	var listener: DogProfileFirstSettingPresentableListener? { get set }
	
	func setBirthday(date: String)
}

protocol DogProfileFirstSettingListener: AnyObject {
	func dogProfileFirstSettingDidTapConfirmButton()
	func dogProfileFirstSettingDidTapBackButton()
	func dogProfileFirstSettingDismiss()
}

final class DogProfileFirstSettingInteractor:
	PresentableInteractor<DogProfileFirstSettingPresentable>,
	DogProfileFirstSettingInteractable,
	DogProfileFirstSettingPresentableListener {
	weak var router: DogProfileFirstSettingRouting?
	weak var listener: DogProfileFirstSettingListener?

	override init(presenter: DogProfileFirstSettingPresentable) {
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
extension DogProfileFirstSettingInteractor {
	func didTapConfirmButton() {
		listener?.dogProfileFirstSettingDidTapConfirmButton()
	}
	
	func didTapBackButton() {
		listener?.dogProfileFirstSettingDidTapBackButton()
	}
	
	func dismiss() {
		listener?.dogProfileFirstSettingDismiss()
	}
}

// MARK: - BirthdayPickerListener
extension DogProfileFirstSettingInteractor {
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
