import RIBs
import OnBoarding

public protocol OnBoardingDependency: Dependency {
	var onBoardingViewController: ViewControllable { get }
	var termsOfUseBuildable: TermsOfUseBuildable { get }
	var profileSettingBuildable: ProfileSettingBuildable { get }
	var addressSettingBuildable: AddressSettingBuildable { get }
}

final class OnBoardingComponent: Component<OnBoardingDependency> {
	fileprivate var onBoardingViewController: ViewControllable {
		dependency.onBoardingViewController
	}
	var profileSettingBuildable: ProfileSettingBuildable {
		dependency.profileSettingBuildable
	}
	var termsOfUseBuildable: TermsOfUseBuildable {
		dependency.termsOfUseBuildable
	}
	var addressSettingBuildable: AddressSettingBuildable {
		dependency.addressSettingBuildable
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
			termsOfUseBuildable: component.termsOfUseBuildable,
			addressSettingBuildable: component.addressSettingBuildable,
			profileSettingBuildable: component.profileSettingBuildable
		)
	}
}
