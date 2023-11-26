import RIBs
import CorePresentation

protocol DogProfileSecondSettingDependency: Dependency {
	var dogCharacterPickerBuildable: DogCharacterPickerBuildable { get }
}

final class DogProfileSecondSettingComponent: Component<DogProfileSecondSettingDependency> { 
	fileprivate var dogCharacterPickerBuildable: DogCharacterPickerBuildable {
		dependency.dogCharacterPickerBuildable
	}
}

protocol DogProfileSecondSettingBuildable: Buildable {
	func build(withListener listener: DogProfileSecondSettingListener) -> ViewableRouting
}

final class DogProfileSecondSettingBuilder:
	Builder<DogProfileSecondSettingDependency>,
	DogProfileSecondSettingBuildable {
	override init(dependency: DogProfileSecondSettingDependency) {
		super.init(dependency: dependency)
	}
	
	func build(withListener listener: DogProfileSecondSettingListener) -> ViewableRouting {
		let component = DogProfileSecondSettingComponent(dependency: dependency)
		let viewController = DogProfileSecondSettingViewController()
		let interactor = DogProfileSecondSettingInteractor(presenter: viewController)
		interactor.listener = listener
		return DogProfileSecondSettingRouter(
			interactor: interactor,
			viewController: viewController,
			dogCharacterPickerBuildable: component.dogCharacterPickerBuildable
		)
	}
}
