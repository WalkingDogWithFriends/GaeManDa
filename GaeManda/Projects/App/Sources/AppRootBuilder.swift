import RIBs
import UIKit

protocol AppRootDependency: Dependency {
	// TODO: Declare the set of dependencies required by this RIB, but cannot be
	// created by this RIB.
}

final class AppRootComponent: Component<AppRootDependency> {
	// TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder
protocol AppRootBuildable: Buildable {
	func build() -> LaunchRouting
}

final class AppRootBuilder: Builder<AppRootDependency>, AppRootBuildable {
	override init(dependency: AppRootDependency) {
		super.init(dependency: dependency)
	}
	
	func build() -> LaunchRouting {
		let component = AppRootComponent(dependency: dependency)
		let viewController = AppRootViewController()
		let interactor = AppRootInteractor(presenter: viewController)
		
		return AppRootRouter(interactor: interactor, viewController: viewController)
	}
}
