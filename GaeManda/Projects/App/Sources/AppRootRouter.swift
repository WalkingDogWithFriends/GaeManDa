import RIBs

protocol AppRootInteractable:
	Interactable,
	LoggedOutListener,
	LoggedInListener {
	var router: AppRootRouting? { get set }
	var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable { }

final class AppRootRouter:
	LaunchRouter <AppRootInteractable, AppRootViewControllable>,
	AppRootRouting {
	private let loggedOutBuildable: LoggedOutBuildable
	private var loggedOutRouting: Routing?
	
	private let loggedInBuildable: LoggedInBuildable
	private var loggedInRouting: ViewableRouting?
	
	init(
		interactor: AppRootInteractable,
		viewController: AppRootViewControllable,
		loggedOutBuildable: LoggedOutBuildable,
		loggedInBuildable: LoggedInBuildable
	) {
		self.loggedOutBuildable = loggedOutBuildable
		self.loggedInBuildable = loggedInBuildable
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
	
	func attachLoggedOut() {
		if loggedOutRouting != nil { return }
		
		let router = loggedOutBuildable.build(withListener: interactor)
		loggedOutRouting = router
		attachChild(router)
	}
	
	func detachLoggedOut() {
		guard let router = loggedOutRouting else { return }
		
		detachChild(router)
		loggedOutRouting = nil
	}
	
	func attachLoggedIn() {
		if loggedInRouting != nil { return }
		
		let router = loggedInBuildable.build(withListener: interactor)
		loggedInRouting = router
		
		attachChild(router)
		viewControllable.present(
			router.viewControllable,
			animated: true,
			modalPresentationStyle: .fullScreen
		)
	}
	
	func detachLoggedIn() {
		guard let router = loggedInRouting else { return }
		
		loggedInRouting = nil
		detachChild(router)
		viewControllable.dismiss(completion: nil)
	}
}
