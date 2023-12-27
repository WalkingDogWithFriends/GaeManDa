import RIBs
import SignIn
import UseCase

public protocol SignInDependency: Dependency {
	var signInUseCase: SignInUseCase { get }
}

final class SignInComponent:
	Component<SignInDependency>,
	SignInInteractorDependency {
	var signInUseCase: SignInUseCase {
		dependency.signInUseCase
	}
}

// MARK: - Builder
public final class SignInBuilder:
	Builder<SignInDependency>,
	SignInBuildable {
	public override init(dependency: SignInDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: SignInListener) -> ViewableRouting {
		let component = SignInComponent(dependency: dependency)
		let viewController = SignInViewController()
		let interactor = SignInInteractor(
			presenter: viewController,
			dependency: component
		)
		interactor.listener = listener
		
		return SignInRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
