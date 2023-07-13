import RIBs

protocol AppRootRouting: ViewableRouting {
	func attachLoggedOut()
	func detachLoggedOut()
}

protocol AppRootPresentable: Presentable {
	var listener: AppRootPresentableListener? { get set }
}

protocol AppRootListener: AnyObject { }

final class AppRootInteractor:
	PresentableInteractor<AppRootPresentable>,
	AppRootInteractable,
	AppRootPresentableListener {
	weak var router: AppRootRouting?
	weak var listener: AppRootListener?
	
	override init(presenter: AppRootPresentable) {
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
