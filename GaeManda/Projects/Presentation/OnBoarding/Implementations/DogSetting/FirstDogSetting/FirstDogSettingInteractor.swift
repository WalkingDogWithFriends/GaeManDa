import RIBs

protocol FirstDogSettingRouting: ViewableRouting { }

protocol FirstDogSettingPresentable: Presentable {
	var listener: FirstDogSettingPresentableListener? { get set }
}

protocol FirstDogSettingListener: AnyObject {
	func firstDogSettingDidFinish()
	func firstDogSettingBackButtonDidTap()
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
}
