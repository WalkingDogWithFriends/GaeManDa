import RIBs

protocol SecondDogSettingRouting: ViewableRouting { }

protocol SecondDogSettingPresentable: Presentable {
	var listener: SecondDogSettingPresentableListener? { get set }
}

protocol SecondDogSettingListener: AnyObject {
	func secondDogSettingDidTapConfirmButton()
	func secondDogSettingDidTaBackButtonp()
	func secondDogSettingDismiss()
}

final class SecondDogSettingInteractor:
	PresentableInteractor<SecondDogSettingPresentable>,
	SecondDogSettingInteractable,
	SecondDogSettingPresentableListener {
	weak var router: SecondDogSettingRouting?
	weak var listener: SecondDogSettingListener?
	
	override init(presenter: SecondDogSettingPresentable) {
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
extension SecondDogSettingInteractor {
	func didTapConfirmButton() {
		listener?.secondDogSettingDidTapConfirmButton()
	}
	
	func didTapBackButton() {
		listener?.secondDogSettingDidTaBackButtonp()
	}
	
	func dismiss() {
		listener?.secondDogSettingDismiss()
	}
}
