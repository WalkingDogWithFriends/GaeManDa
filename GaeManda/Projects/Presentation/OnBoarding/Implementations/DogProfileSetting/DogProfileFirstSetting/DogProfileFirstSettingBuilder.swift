import RIBs
import CorePresentation
import DesignKit
import OnBoarding

protocol DogProfileFirstSettingDependency: Dependency { 
	var dogProfileFirstDashboardBuildable: DogProfileFirstDashboardBuildable { get }
}

final class DogProfileFirstSettingComponent: Component<DogProfileFirstSettingDependency> {
	var dogProfileFirstDashboardBuildable: DogProfileFirstDashboardBuildable {
		dependency.dogProfileFirstDashboardBuildable
	}
}

protocol DogProfileFirstSettingBuildable: Buildable {
	func build(withListener listener: DogProfileFirstSettingListener) -> ViewableRouting
}

final class DogProfileFirstSettingBuilder:
	Builder<DogProfileFirstSettingDependency>,
	DogProfileFirstSettingBuildable {
	override init(dependency: DogProfileFirstSettingDependency) {
		super.init(dependency: dependency)
	}
	
	func build(withListener listener: DogProfileFirstSettingListener) -> ViewableRouting {
		let component = DogProfileFirstSettingComponent(dependency: dependency)
		let viewController = DogProfileFirstSettingViewController()
		let interactor = DogProfileFirstSettingInteractor(presenter: viewController)
		interactor.listener = listener
		
		return DogProfileFirstSettingRouter(
			interactor: interactor,
			viewController: viewController,
			dogProfileFirstDashboardBuildable: component.dogProfileFirstDashboardBuildable
		)
	}
}
