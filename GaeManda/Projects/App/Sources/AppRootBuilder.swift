import RIBs

protocol AppRootDependency: Dependency { }

protocol AppRootBuildable: Buildable {
	func build() -> LaunchRouting
}

final class AppRootBuilder:
	Builder<AppRootDependency>,
	AppRootBuildable {
	override init(dependency: AppRootDependency) {
		super.init(dependency: dependency)
	}
	
	func build() -> LaunchRouting {
		let viewController = AppRootViewController()
		let component = AppRootComponent(
			dependency: dependency,
			rootViewController: viewController
		)

		let interactor = AppRootInteractor(presenter: viewController)
		
		let loggedOut = LoggedOutBuilder(dependency: component)
		
		return AppRootRouter(
			interactor: interactor,
			viewController: viewController,
			loggedOutBuildable: loggedOut
		)
	}
}
