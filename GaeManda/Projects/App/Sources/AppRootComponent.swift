import RIBs
import GMDUtils

final class AppRootComponent:
	Component<AppRootDependency>,
	LoggedOutDependency {
	lazy var loggedOutBuildable: LoggedOutBuildable = {
		return LoggedOutBuilder(dependency: self)
	}()
	
	var loggedOutViewController: ViewControllable {
		rootViewController.topViewControllable
	}
	
	private let rootViewController: ViewControllable
	
	init(
		dependency: AppRootDependency,
		rootViewController: ViewControllable
	) {
		self.rootViewController = rootViewController
		super.init(dependency: dependency)
	}
}
