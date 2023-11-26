import RIBs
import CorePresentation
import DesignKit
import OnBoarding

public protocol UserProfileSettingDependency: Dependency { 
	var birthdayPickerBuildable: BirthdayPickerBuildable { get }
}

final class UserProfileSettingComponent: Component<UserProfileSettingDependency> { 
	var birthdayPickerBuildable: BirthdayPickerBuildable {
		dependency.birthdayPickerBuildable
	}
}

public final class UserProfileSettingBuilder:
	Builder<UserProfileSettingDependency>,
	UserProfileSettingBuildable {
	public override init(dependency: UserProfileSettingDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: UserProfileSettingListener) -> ViewableRouting {
		let component = UserProfileSettingComponent(dependency: dependency)
		let viewController = UserProfileSettingViewController()
		let interactor = UserProfileSettingInteractor(presenter: viewController)
		interactor.listener = listener
		return ProfileSettingRouter(
			interactor: interactor,
			viewController: viewController,
			birthdayPickerBuildable: component.birthdayPickerBuildable
		)
	}
}
