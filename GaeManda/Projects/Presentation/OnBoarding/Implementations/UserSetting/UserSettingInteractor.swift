import RIBs
import OnBoarding

protocol UserSettingRouting: ViewableRouting { }

protocol UserSettingPresentable: Presentable {
	var listener: UserSettingPresentableListener? { get set }
}

final class UserSettingInteractor:
	PresentableInteractor<UserSettingPresentable>,
	UserSettingInteractable,
	UserSettingPresentableListener {
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
	func didTapConfirmButton() {
		listener?.userSettingDidFinish()
	}
}
