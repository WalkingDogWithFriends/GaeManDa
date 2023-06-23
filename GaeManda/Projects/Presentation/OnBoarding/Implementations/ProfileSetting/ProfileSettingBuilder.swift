import RIBs
import OnBoarding

public protocol ProfileSettingDependency: Dependency { }

final class ProfileSettingComponent: Component<ProfileSettingDependency> { }

public final class ProfileSettingBuilder:
	Builder<ProfileSettingDependency>,
	ProfileSettingBuildable {
	public override init(dependency: ProfileSettingDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: ProfileSettingListener) -> ViewableRouting {
		let viewController = ProfileSettingViewController()
		let interactor = ProfileSettingInteractor(presenter: viewController)
		interactor.listener = listener
		return ProfileSettingRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
