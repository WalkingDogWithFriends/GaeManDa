import RIBs

protocol LoggedOutDependency: Dependency {
	var loggedOutViewController: ViewControllable { get }
}

protocol LoggedOutBuildable: Buildable {
	func build(withListener listener: LoggedOutListener) -> Routing
}

final class LoggedOutBuilder:
	Builder<LoggedOutDependency>,
	LoggedOutBuildable {
	override init(dependency: LoggedOutDependency) {
		super.init(dependency: dependency)
	}
	
	func build(withListener listener: LoggedOutListener) -> Routing {
		let component = LoggedOutComponent(dependency: dependency)
		let interactor = LoggedOutInteractor()
		interactor.listener = listener
		
		return LoggedOutRouter(
			interactor: interactor,
			viewController: component.loggedOutViewController,
			signInBuildable: component.signInBuildable,
			onBoardingBuildable: component.onBoardingBuildable
		)
	}
}
