import RIBs
import OnBoarding

protocol ProfileSettingRouting: ViewableRouting { }

protocol ProfileSettingPresentable: Presentable {
	var listener: ProfileSettingPresentableListener? { get set }
}

final class ProfileSettingInteractor:
	PresentableInteractor<ProfileSettingPresentable>,
	ProfileSettingInteractable,
	ProfileSettingPresentableListener {
	weak var router: ProfileSettingRouting?
	weak var listener: ProfileSettingListener?
	
	override init(presenter: ProfileSettingPresentable) {
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
