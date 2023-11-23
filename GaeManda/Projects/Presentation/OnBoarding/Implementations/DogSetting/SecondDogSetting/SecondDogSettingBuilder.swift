import RIBs
import CorePresentation

protocol SecondDogSettingDependency: Dependency { 
	var dogCharacterPickerBuildable: DogCharacterPickerBuildable { get }
}

final class SecondDogSettingComponent: Component<SecondDogSettingDependency> {
	fileprivate var dogCharacterPickerBuildable: DogCharacterPickerBuildable {
		dependency.dogCharacterPickerBuildable
	}
}

protocol SecondDogSettingBuildable: Buildable {
	func build(withListener listener: SecondDogSettingListener) -> ViewableRouting
}

final class SecondDogSettingBuilder:
	Builder<SecondDogSettingDependency>,
	SecondDogSettingBuildable {
	override init(dependency: SecondDogSettingDependency) {
		super.init(dependency: dependency)
	}
	
	func build(withListener listener: SecondDogSettingListener) -> ViewableRouting {
		let component = SecondDogSettingComponent(dependency: dependency)
		let viewController = SecondDogSettingViewController()
		let interactor = SecondDogSettingInteractor(presenter: viewController)
		interactor.listener = listener
		return SecondDogSettingRouter(
			interactor: interactor,
			viewController: viewController,
			dogCharacterPickerBuildable: component.dogCharacterPickerBuildable
		)
	}
}
