import RIBs

protocol FirstDogSettingRouting: ViewableRouting { }

protocol FirstDogSettingPresentable: Presentable {
	var listener: FirstDogSettingPresentableListener? { get set }
}

protocol FirstDogSettingListener: AnyObject {
	func firstDogSettingDidTapConfirmButton()
	func firstDogSettingDidTapBackButton()
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
	func didTapConfirmButton() {
		listener?.firstDogSettingDidTapConfirmButton()
	}
	
	func didTapBackButton() {
		listener?.firstDogSettingDidTapBackButton()
	}
	
	func dismiss() {
		listener?.firstDogSettingDismiss()
	}
}
