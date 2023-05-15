import RIBs
import UIKit

protocol AppRootDependency: Dependency { }

final class AppRootComponent: Component<AppRootDependency> { }

protocol AppRootBuildable: Buildable {
	func build() -> LaunchRouting
}

final class AppRootBuilder: Builder<AppRootDependency>, AppRootBuildable {
	override init(dependency: AppRootDependency) {
		super.init(dependency: dependency)
	}
	
	func build() -> LaunchRouting {
		// let component = AppRootComponent(dependency: dependency)
		let viewController = AppRootViewController()
		let interactor = AppRootInteractor(presenter: viewController)
		
		return AppRootRouter(interactor: interactor, viewController: viewController)
	}
}
