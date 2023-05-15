import RIBs

protocol AppRootInteractable: Interactable {
	var router: AppRootRouting? { get set }
	var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable { }

final class AppRootRouter: LaunchRouter <AppRootInteractable, AppRootViewControllable>, AppRootRouting {
	override init(interactor: AppRootInteractable, viewController: AppRootViewControllable) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
