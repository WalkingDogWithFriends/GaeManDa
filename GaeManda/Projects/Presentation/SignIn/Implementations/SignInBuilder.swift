import RIBs
import SignIn

public protocol SignInDependency: Dependency { }

final class SignInComponent: Component<SignInDependency> { }

// MARK: - Builder
public final class SignInBuilder:
	Builder<SignInDependency>,
	SignInBuildable {
	public override init(dependency: SignInDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: SignInListener) -> ViewableRouting {
		let viewController = SignInViewController()
		let interactor = SignInInteractor(presenter: viewController)
		interactor.listener = listener
		return SignInRouter(interactor: interactor, viewController: viewController)
	}
}
