import RIBs
import DesignKit
import OnBoarding

protocol FirstDogSettingDependency: Dependency { 
	var birthdayPickerBuildable: BirthdayPickerBuildable { get }
}

final class FirstDogSettingComponent: Component<FirstDogSettingDependency> {
	var birthdayPickerBuildable: BirthdayPickerBuildable {
		dependency.birthdayPickerBuildable
	}
}

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
		let component = FirstDogSettingComponent(dependency: dependency)
		let viewController = FirstDogSettingViewController()
		let interactor = FirstDogSettingInteractor(presenter: viewController)
		interactor.listener = listener
		return FirstDogSettingRouter(
			interactor: interactor,
			viewController: viewController,
			birthdayPickerBuildable: component.birthdayPickerBuildable
		)
	}
}
