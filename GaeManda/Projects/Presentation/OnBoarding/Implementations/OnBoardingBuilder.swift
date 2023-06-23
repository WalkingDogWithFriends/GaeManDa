import RIBs
import OnBoarding

public protocol OnBoardingDependency: Dependency {
	var onBoardingViewController: ViewControllable { get }
	var profileSettingBuildable: ProfileSettingBuildable { get }
}

final class OnBoardingComponent: Component<OnBoardingDependency> {
	fileprivate var onBoardingViewController: ViewControllable {
		dependency.onBoardingViewController
	}
	var profileSettingBuildable: ProfileSettingBuildable {
		dependency.profileSettingBuildable
	}
}

public final class OnBoardingBuilder:
	Builder<OnBoardingDependency>,
	OnBoardingBuildable {
	public override init(dependency: OnBoardingDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: OnBoardingListener) -> Routing {
		let component = OnBoardingComponent(dependency: dependency)
		let interactor = OnBoardingInteractor()
		interactor.listener = listener
		return OnBoardingRouter(
			interactor: interactor,
			viewController: component.onBoardingViewController,
			profileSettingBuildable: component.profileSettingBuildable
		)
	}
}
