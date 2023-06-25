import RIBs
import OnBoarding
import OnBoardingImpl
import Utils

final class LoggedOutComponent:
	Component<LoggedOutDependency>,
	OnBoardingDependency,
	TermsOfUseDependency,
	AddressSettingDependency,
	ProfileSettingDependency {
	lazy var onBoardingBuildable: OnBoardingBuildable = {
		return OnBoardingBuilder(dependency: self)
	}()
	
	lazy var termsOfUseBuildable: TermsOfUseBuildable = {
		return TermsOfUseBuilder(dependency: self)
	}()
	
	lazy var addressSettingBuildable: AddressSettingBuildable = {
		return AddressSettingBuilder(dependency: self)
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
