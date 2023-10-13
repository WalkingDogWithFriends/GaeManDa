import RIBs
import OnBoarding

public protocol UserSettingDependency: Dependency { 
	var birthdayPickerBuildable: BirthdayPickerBuildable { get }
}

final class UserSettingComponent: Component<UserSettingDependency> { 
	var birthdayPickerBuildable: BirthdayPickerBuildable {
		dependency.birthdayPickerBuildable
	}
}

public final class UserSettingBuilder:
	Builder<UserSettingDependency>,
	UserSettingBuildable {
	public override init(dependency: UserSettingDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: UserSettingListener) -> ViewableRouting {
		let component = UserSettingComponent(dependency: dependency)
		let viewController = UserSettingViewController()
		let interactor = UserSettingInteractor(presenter: viewController)
		interactor.listener = listener
		return ProfileSettingRouter(
			interactor: interactor,
			viewController: viewController,
			birthdayPickerBuildable: component.birthdayPickerBuildable
		)
	}
}
