import RIBs

protocol FirstDogSettingDependency: Dependency { }

final class FirstDogSettingComponent: Component<FirstDogSettingDependency> { }

protocol FirstDogSettingBuildable: Buildable {
	func build(withListener listener: FirstDogSettingListener) -> ViewableRouting
}

final class FirstDogSettingBuilder:
	Builder<FirstDogSettingDependency>,
	FirstDogSettingBuildable {
	override init(dependency: FirstDogSettingDependency) {
		super.init(dependency: dependency)
	}
	
	func build(withListener listener: FirstDogSettingListener) -> ViewableRouting {
		let viewController = FirstDogSettingViewController()
		let interactor = FirstDogSettingInteractor(presenter: viewController)
		interactor.listener = listener
		return FirstDogSettingRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
