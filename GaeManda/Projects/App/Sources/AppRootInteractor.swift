import Foundation
import RIBs
import UseCase

protocol AppRootRouting: ViewableRouting {
	func attachLoggedOut()
	func detachLoggedOut()
	func attachLoggedIn()
	func detachLoggedIn()
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
	
	private let signInUseCase: SignInUseCase
	
	init(presenter: AppRootPresentable, signInUseCase: SignInUseCase) {
		self.signInUseCase = signInUseCase
		super.init(presenter: presenter)
		presenter.listener = self
	}
	
	override func didBecomeActive() {
		super.didBecomeActive()
		
		let isAuthorized = signInUseCase.isAuthorized()
		let isOnboardingFinished = signInUseCase.isOnboardingFinished()
		if isAuthorized && isOnboardingFinished {
			router?.attachLoggedIn()
		} else {
			router?.attachLoggedOut()
		}
	}
	
	override func willResignActive() {
		super.willResignActive()
	}
}

// MARK: - LoggedOutListener
extension AppRootInteractor {
	func loggedOutDidFinish() {
		router?.detachLoggedOut()
		router?.attachLoggedIn()
	}
}
