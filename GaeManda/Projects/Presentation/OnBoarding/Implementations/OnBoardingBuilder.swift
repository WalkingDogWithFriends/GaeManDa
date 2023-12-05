import RIBs
import OnBoarding
import UseCase

public protocol OnBoardingDependency: Dependency {
	var onBoardingViewController: ViewControllable { get }
	var termsOfUseBuildable: TermsOfUseBuildable { get }
	var addressSettingBuildable: AddressSettingBuildable { get }
	var userProfileSettingBuildable: UserProfileSettingBuildable { get }
	var dogProfileSettingBuildable: DogProfileSettingBuildable { get }
	var onBoardingUseCase: OnBoardingUseCase { get }
}

final class OnBoardingComponent: 
	Component<OnBoardingDependency>,
	OnBoardingInteractorDependency {
	var onBoardingUseCase: OnBoardingUseCase {
		dependency.onBoardingUseCase
	}
	
	fileprivate var onBoardingViewController: ViewControllable {
		dependency.onBoardingViewController
	}
	fileprivate var termsOfUseBuildable: TermsOfUseBuildable {
		dependency.termsOfUseBuildable
	}
	fileprivate var addressSettingBuildable: AddressSettingBuildable {
		dependency.addressSettingBuildable
	}
	fileprivate var userProfileSettingBuildable: UserProfileSettingBuildable {
		dependency.userProfileSettingBuildable
	}
	fileprivate var dogProfileSettingBuildable: DogProfileSettingBuildable {
		dependency.dogProfileSettingBuildable
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
		let interactor = OnBoardingInteractor(dependency: component)
		interactor.listener = listener
		return OnBoardingRouter(
			interactor: interactor,
			viewController: component.onBoardingViewController,
			termsOfUseBuildable: component.termsOfUseBuildable,
			addressSettingBuildable: component.addressSettingBuildable,
			userProfileSettingBuildable: component.userProfileSettingBuildable,
			dogProfileSettingBuildable: component.dogProfileSettingBuildable
		)
	}
}
