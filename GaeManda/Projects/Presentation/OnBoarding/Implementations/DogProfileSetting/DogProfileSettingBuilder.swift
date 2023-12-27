import RIBs
import CorePresentation
import DesignKit
import GMDUtils
import OnBoarding
import UseCase

public protocol DogProfileSettingDependency: Dependency {
	var dogProfileSettingViewController: ViewControllable { get }
	var dogProfileFirstDashboardBuildable: DogProfileFirstDashboardBuildable { get }
	var dogProfileSecondDashboardBuildable: DogProfileSecondDashboardBuildable { get }
	var dogCharacterPickerBuildable: DogCharacterPickerBuildable { get }
	var dogCharacterDashboardBuildable: DogCharacterDashboardBuildable { get }
	var onBoardingUseCase: OnBoardingUseCase { get }
}

final class DogProfileSettingComponent:
	Component<DogProfileSettingDependency>,
	DogProfileFirstSettingDependency,
	DogProfileSecondSettingDependency {
	fileprivate var dogProfileSettingViewController: ViewControllable {
		return dependency.dogProfileSettingViewController
	}
	
	var onBoardingUseCase: OnBoardingUseCase {
		return dependency.onBoardingUseCase
	}
	
	var dogProfileFirstDashboardBuildable: DogProfileFirstDashboardBuildable {
		dependency.dogProfileFirstDashboardBuildable
	}
	
	var dogProfileSecondDashboardBuildable: DogProfileSecondDashboardBuildable {
		dependency.dogProfileSecondDashboardBuildable
	}
	
	var dogCharacterPickerBuildable: DogCharacterPickerBuildable {
		return dependency.dogCharacterPickerBuildable
	}
	
	var dogCharacterDashboardBuildable: DogCharacterDashboardBuildable {
		return dependency.dogCharacterDashboardBuildable
	}
}

public final class DogProfileSettingBuilder: Builder<DogProfileSettingDependency>, DogProfileSettingBuildable {
	public override init(dependency: DogProfileSettingDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: DogProfileSettingListener) -> Routing {
		let component = DogProfileSettingComponent(dependency: dependency)
		let interactor = DogProfileSettingInteractor()
		interactor.listener = listener
		
		let dogProfileFirstSettingBuildable = DogProfileFirstSettingBuilder(dependency: component)
		let dogProfileSecondSettingBuildable = DogProfileSecondSettingBuilder(dependency: component)
		
		return DogProfileSettingRouter(
			interactor: interactor,
			viewController: component.dogProfileSettingViewController,
			dogProfileFirstSettingBuildable: dogProfileFirstSettingBuildable,
			dogProfileSecondSettingBuildable: dogProfileSecondSettingBuildable
		)
	}
}
