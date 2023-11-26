import RIBs
import CorePresentation
import DataMapper
import DesignKit
import GMDUtils
import OnBoarding
import OnBoardingImpl
import SignIn
import SignInImpl
import UseCase
import UseCaseImpl
import Repository
import RepositoryImpl

final class LoggedOutComponent:
	Component<LoggedOutDependency>,
	SignInDependency,
	OnBoardingDependency,
	TermsOfUseDependency,
	AddressSettingDependency,
	DetailAddressSettingDependency,
	UserProfileSettingDependency,
	DogProfileSettingDependency {
	var dogCharacterPickerBuildable: DogCharacterPickerBuildable {
		return dependency.dogCharacterPickerBuildable
	}
	
	lazy var onBoardingBuildable: OnBoardingBuildable = {
		return OnBoardingBuilder(dependency: self)
	}()
	
	lazy var termsOfUseBuildable: TermsOfUseBuildable = {
		return TermsOfUseBuilder(dependency: self)
	}()
	
	lazy var addressSettingBuildable: AddressSettingBuildable = {
		return AddressSettingBuilder(dependency: self)
	}()
	
	// MARK: Detail Address Setting
	lazy var detailAddressSettingBuildable: DetailAddressSettingBuildable = {
		return DetailAddressSettingBuilder(dependency: self)
	}()
	
	lazy var geocodeRepository: GeocodeRepository = {
		return GeocodingRepositoryImpl()
	}()
	
	var detailAddressUseCase: DetailAddressSettingUseCase {
		return DetailAddressSettingUseCaseImpl(geocodeRepository: geocodeRepository)
	}
	
	lazy var userProfileSettingBuildable: UserProfileSettingBuildable = {
		return UserProfileSettingBuilder(dependency: self)
	}()
	
	lazy var dogProfileSettingBuildable: DogProfileSettingBuildable = {
		return DogProfileSettingBuilder(dependency: self)
	}()
	
	lazy var signInBuildable: SignInBuildable = {
		return SignInBuilder(dependency: self)
	}()
	
	var onBoardingViewController: ViewControllable {
		dependency.loggedOutViewController
	}
	var dogProfileSettingViewController: ViewControllable {
		loggedOutViewController.topViewControllable
	}
	var loggedOutViewController: ViewControllable {
		dependency.loggedOutViewController
	}
	
	var birthdayPickerBuildable: BirthdayPickerBuildable {
		return dependency.birthdayPickerBuildable
	}
	
	var onboardingRepositry: OnboardingRepository {
		shared { OnboardingRepositoryImpl(dataMapper: TermsMapperImpl()) }
	}
	
	var termsOfUseUseCase: TermsofUseUseCase {
		return TermsofUseUseCaseImpl(repository: onboardingRepositry)
	}
}
