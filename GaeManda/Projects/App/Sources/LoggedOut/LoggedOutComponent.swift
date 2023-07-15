import RIBs
import GMDUtils
import OnBoarding
import OnBoardingImpl

final class LoggedOutComponent:
	Component<LoggedOutDependency>,
	OnBoardingDependency,
	TermsOfUseDependency,
	AddressSettingDependency,
	DetailAddressSettingDependency,
	UserSettingDependency,
	DogSettingDependency {
	lazy var onBoardingBuildable: OnBoardingBuildable = {
		return OnBoardingBuilder(dependency: self)
	}()
	
	lazy var termsOfUseBuildable: TermsOfUseBuildable = {
		return TermsOfUseBuilder(dependency: self)
	}()
	
	lazy var addressSettingBuildable: AddressSettingBuildable = {
		return AddressSettingBuilder(dependency: self)
	}()
	
	lazy var detailAddressSettingBuildable: DetailAddressSettingBuildable = {
		return DetailAddressSettingBuilder(dependency: self)
	}()
	
	lazy var userSettingBuildable: UserSettingBuildable = {
		return UserSettingBuilder(dependency: self)
	}()
	
	lazy var dogSettingBuildable: DogSettingBuildable = {
		return DogSettingBuilder(dependency: self)
	}()
	
	var onBoardingViewController: ViewControllable {
		loggedOutViewController.topViewControllable
	}
	
	var dogSettingViewController: ViewControllable {
		loggedOutViewController.topViewControllable
	}

	var loggedOutViewController: ViewControllable {
		dependency.loggedOutViewController
	}
}
