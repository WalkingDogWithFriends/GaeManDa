import RIBs

import SignIn

protocol SignInDependency: Dependency { }

final class SignInComponent: Component<SignInDependency> { }

// MARK: - Builder
final class SignInBuilder: Builder<SignInDependency>, SignInBuildable {
	override init(dependency: SignInDependency) {
		super.init(dependency: dependency)
	}
	
	func build(withListener listener: SignInListener) -> ViewableRouting {
		//        let component = SignInComponent(dependency: dependency)
		let viewController = SignInViewController()
		let interactor = SignInInteractor(presenter: viewController)
		interactor.listener = listener
		return SignInRouter(interactor: interactor, viewController: viewController)
	}
}
