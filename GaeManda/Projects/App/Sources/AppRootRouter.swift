import RIBs

protocol AppRootInteractable:
	Interactable,
	LoggedOutListener {
	var router: AppRootRouting? { get set }
	var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable { }

final class AppRootRouter:
	LaunchRouter <AppRootInteractable, AppRootViewControllable>,
	AppRootRouting {
	private let loggedOutBuildable: LoggedOutBuildable
	private var loggedOutRouting: Routing?
	
	init(
		interactor: AppRootInteractable,
		viewController: AppRootViewControllable,
		loggedOutBuildable: LoggedOutBuildable
	) {
		self.loggedOutBuildable = loggedOutBuildable
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
	
	override func didLoad() {
		super.didLoad()
		attachLoggedOut()
	}
	
	func attachLoggedOut() {
		if loggedOutRouting != nil { return }
		
		let router = loggedOutBuildable.build(withListener: interactor)
		loggedOutRouting = router
		attachChild(router)
	}
	
	func detachLoggedOut() {
		guard let router = loggedOutRouting else { return }
		loggedOutRouting = nil
		detachChild(router)
	}
}
