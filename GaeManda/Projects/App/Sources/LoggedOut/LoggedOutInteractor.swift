import RIBs
import UseCase

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

	private let signInUseCase: SignInUseCase
	
	init(signInUseCase: SignInUseCase) {
		self.signInUseCase = signInUseCase
	}
	
	override func didBecomeActive() {
		super.didBecomeActive()
		router?.attachSignIn()
//		
//		let isAuthorized = signInUseCase.isAuthorized()
//		let isOnboardingFinished = signInUseCase.isOnboardingFinished()
//				
//		if !isAuthorized && isOnboardingFinished {
//			// 온보딩은 했는데 로그인을 안 한 경우
//			router?.attachSignIn()
//		} else if isAuthorized && !isOnboardingFinished {
//			// 로그인은 했는데 온보딩을 안한 경우
//			router?.attachOnBoarding()
//		} else {
//			router?.attachSignIn()
//		}
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
	func didSignIn(hasOnboardingFinished: Bool) {
		router?.detachSignIn()
		if hasOnboardingFinished {
			listener?.loggedOutDidFinish()
		} else {
			router?.attachOnBoarding()
		}
	}
}
