import RIBs

protocol LoggedOutRouting: Routing {
	func cleanupViews()
	func attachOnBoarding()
	func detachOnBoarding()
}

protocol LoggedOutListener: AnyObject { }

final class LoggedOutInteractor: Interactor, LoggedOutInteractable {
	weak var router: LoggedOutRouting?
	weak var listener: LoggedOutListener?

	override init() {}
	
	override func didBecomeActive() {
		super.didBecomeActive()
	}
	
	override func willResignActive() {
		super.willResignActive()
		
		router?.cleanupViews()
	}
}

// MARK: OnBoardingListener
extension LoggedOutInteractor {
	func onBoardingDidFinish() {
		router?.detachOnBoarding()
	}
}
