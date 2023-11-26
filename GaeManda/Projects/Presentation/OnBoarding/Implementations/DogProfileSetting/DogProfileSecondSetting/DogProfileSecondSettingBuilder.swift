import RIBs

protocol DogProfileSecondSettingDependency: Dependency { }

final class DogProfileSecondSettingComponent: Component<DogProfileSecondSettingDependency> { }

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
		let viewController = DogProfileSecondSettingViewController()
		let interactor = DogProfileSecondSettingInteractor(presenter: viewController)
		interactor.listener = listener
		return DogProfileSecondSettingRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
