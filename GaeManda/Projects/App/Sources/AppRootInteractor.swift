import Foundation
import RIBs
import GMDExtensions

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
	
	private var isUserLogIn: Bool {
//		UserDefaultsManager.shared.removeAllData()
		return UserDefaultsManager.shared.getUser() != nil
	}
	
	override init(presenter: AppRootPresentable) {
		super.init(presenter: presenter)
		presenter.listener = self
	}
	
	override func didBecomeActive() {
		super.didBecomeActive()
		
		isUserLogIn ? router?.attachLoggedIn() : router?.attachLoggedOut()
	}
	
	override func willResignActive() {
		super.willResignActive()
	}
}

extension AppRootInteractor {
	func loggedOutDidFinish() {
		router?.detachLoggedOut()
		router?.attachLoggedIn()
	}
}
