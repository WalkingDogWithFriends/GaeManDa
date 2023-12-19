import RIBs
import CorePresentation
import CorePresentationImpl
import DataMapper
import GMDNetwork
import GMDUtils
import UseCase
import UseCaseImpl
import Repository
import RepositoryImpl
import LocalStorage

protocol AppRootDependency: Dependency {
	var appDataMapper: AppDataMapper { get }
	var requestInterceptor: Interceptor { get }
	var session: Session { get }
	var keychainStorage: KeyChainStorage { get }
}

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

		let interactor = AppRootInteractor(
			presenter: viewController,
			signInUseCase: component.signInUseCase
		)
		
		let loggedOut = LoggedOutBuilder(dependency: component)
		let loggedIn = LoggedInBuilder(dependency: component)
		
		return AppRootRouter(
			interactor: interactor,
			viewController: viewController,
			loggedOutBuildable: loggedOut,
			loggedInBuildable: loggedIn
		)
	}
}
