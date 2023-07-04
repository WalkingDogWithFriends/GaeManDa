import RIBs
import OnBoarding

protocol AddressSettingRouting: ViewableRouting { }

protocol AddressSettingPresentable: Presentable {
	var listener: AddressSettingPresentableListener? { get set }
}

final class AddressSettingInteractor:
	PresentableInteractor<AddressSettingPresentable>,
	AddressSettingInteractable,
	AddressSettingPresentableListener {
	weak var router: AddressSettingRouting?
	weak var listener: AddressSettingListener?
	
	override init(presenter: AddressSettingPresentable) {
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
extension AddressSettingInteractor {
	func confirmButtonDidTap() {
		listener?.addressSettingDidFinish()
	}
}
