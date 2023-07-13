import RIBs

protocol SecondDogSettingDependency: Dependency { }

final class SecondDogSettingComponent: Component<SecondDogSettingDependency> { }

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
		let viewController = SecondDogSettingViewController()
		let interactor = SecondDogSettingInteractor(presenter: viewController)
		interactor.listener = listener
		return SecondDogSettingRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
