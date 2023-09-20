import RIBs

protocol LoggedOutRouting: Routing {
	func cleanupViews()
	func attachSignIn()
	func detachSignIn()
	func attachOnBoarding()
	func detachOnBoarding()
}

protocol LoggedOutListener: AnyObject { 
	func loggedOutDidFinish()
}

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
		listener?.loggedOutDidFinish()
	}
}

// MARK: - SignInListener
extension LoggedOutInteractor {
	func didSignIn(isFirst: Bool) {
		router?.detachSignIn()

		if isFirst {
			router?.attachOnBoarding()
		} else {
			listener?.loggedOutDidFinish()
		}
	}
}
