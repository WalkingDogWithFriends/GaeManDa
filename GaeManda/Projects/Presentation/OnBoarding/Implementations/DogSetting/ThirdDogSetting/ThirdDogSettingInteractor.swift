import RIBs

protocol ThirdDogSettingRouting: ViewableRouting { }

protocol ThirdDogSettingPresentable: Presentable {
	var listener: ThirdDogSettingPresentableListener? { get set }
}

protocol ThirdDogSettingListener: AnyObject {
	func thirdDogSettingDidFinish()
	func thirdDogSettingBackButtonDidTap()
	func thirdDogSettingDismiss()
}

final class ThirdDogSettingInteractor:
	PresentableInteractor<ThirdDogSettingPresentable>,
	ThirdDogSettingInteractable,
	ThirdDogSettingPresentableListener {
	weak var router: ThirdDogSettingRouting?
	weak var listener: ThirdDogSettingListener?
	
	override init(presenter: ThirdDogSettingPresentable) {
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
extension ThirdDogSettingInteractor {
	func confirmButtonDidTap() {
		listener?.thirdDogSettingDidFinish()
	}
	
	func backButtonDidTap() {
		listener?.thirdDogSettingBackButtonDidTap()
	}
	
	func dismiss() {
		listener?.thirdDogSettingDismiss()
	}
}
