import RIBs
import DesignKit
import GMDUtils

final class AppRootComponent:
	Component<AppRootDependency>,
	LoggedOutDependency,
	LoggedInDependency,
	BirthdayPickerDependency {
	lazy var birthdayPickerBuildable: BirthdayPickerBuildable = {
		return BirthdayPickerBuilder(dependency: self)
	}()
	
	lazy var loggedOutBuildable: LoggedOutBuildable = {
		return LoggedOutBuilder(dependency: self)
	}()
	
	var loggedOutViewController: ViewControllable {
		rootViewController
	}
	
	private let rootViewController: ViewControllable
	
	init(
		dependency: AppRootDependency,
		rootViewController: ViewControllable
	) {
		self.rootViewController = rootViewController
		super.init(dependency: dependency)
	}
}
