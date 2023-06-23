import RIBs
import Utils
import OnBoardingImpl
import OnBoarding

final class LoggedOutComponent:
	Component<LoggedOutDependency>,
	OnBoardingDependency,
	ProfileSettingDependency {
	lazy var onBoardingBuildable: OnBoardingBuildable = {
		return OnBoardingBuilder(dependency: self)
	}()
	
	lazy var profileSettingBuildable: ProfileSettingBuildable = {
		return ProfileSettingBuilder(dependency: self)
	}()

	var onBoardingViewController: ViewControllable {
		loggedOutViewController.topViewControllable
	}
	
	var loggedOutViewController: ViewControllable {
		dependency.loggedOutViewController
	}
}
