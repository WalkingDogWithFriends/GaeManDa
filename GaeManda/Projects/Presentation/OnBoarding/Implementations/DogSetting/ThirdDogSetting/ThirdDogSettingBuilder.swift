import RIBs

protocol ThirdDogSettingDependency: Dependency { }

final class ThirdDogSettingComponent: Component<ThirdDogSettingDependency> { }

// MARK: - Builder

protocol ThirdDogSettingBuildable: Buildable {
	func build(withListener listener: ThirdDogSettingListener) -> ViewableRouting
}

final class ThirdDogSettingBuilder: Builder<ThirdDogSettingDependency>, ThirdDogSettingBuildable {
	override init(dependency: ThirdDogSettingDependency) {
		super.init(dependency: dependency)
	}
	
	func build(withListener listener: ThirdDogSettingListener) -> ViewableRouting {
		let viewController = ThirdDogSettingViewController()
		let interactor = ThirdDogSettingInteractor(presenter: viewController)
		interactor.listener = listener
		return ThirdDogSettingRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
