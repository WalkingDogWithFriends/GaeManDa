import RIBs
import DesignKit
import GMDUtils
import OnBoarding
import OnBoardingImpl
import SignIn
import SignInImpl

final class LoggedOutComponent:
	Component<LoggedOutDependency>,
	SignInDependency,
	OnBoardingDependency,
	TermsOfUseDependency,
	AddressSettingDependency,
	DetailAddressSettingDependency,
	UserSettingDependency,
	BirthdayPickerDependency,
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
	
	lazy var birthdayPickerBuildable: BirthdayPickerBuildable = {
		return BirthdayPickerBuilder(dependency: self)
	}()
	
	lazy var dogSettingBuildable: DogSettingBuildable = {
		return DogSettingBuilder(dependency: self)
	}()
	
	lazy var signInBuildable: SignInBuildable = {
		return SignInBuilder(dependency: self)
	}()
	
	var onBoardingViewController: ViewControllable {
		dependency.loggedOutViewController
	}
	var dogSettingViewController: ViewControllable {
		loggedOutViewController.topViewControllable
	}
	var loggedOutViewController: ViewControllable {
		dependency.loggedOutViewController
	}
}
