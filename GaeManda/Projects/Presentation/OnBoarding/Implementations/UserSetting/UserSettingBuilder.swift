import RIBs
import OnBoarding

public protocol UserSettingDependency: Dependency { }

final class UserSettingComponent: Component<UserSettingDependency> { }

public final class UserSettingBuilder:
	Builder<UserSettingDependency>,
	UserSettingBuildable {
	public override init(dependency: UserSettingDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: UserSettingListener) -> ViewableRouting {
		let viewController = UserSettingViewController()
		let interactor = UserSettingInteractor(presenter: viewController)
		interactor.listener = listener
		return ProfileSettingRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
