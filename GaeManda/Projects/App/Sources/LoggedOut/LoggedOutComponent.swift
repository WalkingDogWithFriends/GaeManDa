import RIBs
import CorePresentation
import DataMapper
import GMDUtils
import LocalStorage
import OnBoarding
import OnBoardingImpl
import Repository
import RepositoryImpl
import SignIn
import SignInImpl
import UseCase
import UseCaseImpl

final class LoggedOutComponent:
	Component<LoggedOutDependency>,
	SignInDependency,
	OnBoardingDependency,
	TermsOfUseDependency,
	AddressSettingDependency,
	DetailAddressSettingDependency,
	UserProfileSettingDependency,
	DogProfileSettingDependency {
	lazy var dogCharacterPickerBuildable: DogCharacterPickerBuildable = {
		return dependency.dogCharacterPickerBuildable
	}()
	
	lazy var birthdayPickerBuildable: BirthdayPickerBuildable = {
		return dependency.birthdayPickerBuildable
	}()
	
	lazy var dogCharacterDashboardBuildable: DogCharacterDashboardBuildable = {
		return dependency.dogCharacterDashboardBuildable
	}()
	
	lazy var signInBuildable: SignInBuildable = {
		return SignInBuilder(dependency: self)
	}()
	
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
	
	lazy var userProfileSettingBuildable: UserProfileSettingBuildable = {
		return UserProfileSettingBuilder(dependency: self)
	}()
	
	lazy var dogProfileSettingBuildable: DogProfileSettingBuildable = {
		return DogProfileSettingBuilder(dependency: self)
	}()
	
	// MARK: - Repositories
	lazy var geocodeRepository: GeocodeRepository = {
		return GeocodeRepositoryImpl(dataMapper: GeocodeDataMapperImpl())
	}()
	
	var keyChainStorage: KeyChainStorage = KeyChainStorage.shared
	
	var signInRepository: SignInRepository {
		SignInRepositoryImpl(keychainStorage: keyChainStorage)
	}
	
	// MARK: - UseCases
	lazy var signInUseCase: SignInUseCase = SignInUseCaseImpl(signinRespository: signInRepository)
	
	lazy var termsRepository: TermsRepository = {
		return TermsRepositoryImpl(dataMapper: TermsDataMapperImpl())
	}()
	
	lazy var onBoardingUseCase: OnBoardingUseCase = {
		return OnBoardingUseCaseImpl(
			dogRepository: dependency.dogRepository,
			userRepository: dependency.userRepository,
			geocodeRepository: geocodeRepository,
			termsRepository: termsRepository
		)
	}()
	
	// MARK: - ViewControllerable
	var onBoardingViewController: ViewControllable {
		dependency.loggedOutViewController
	}
	var dogProfileSettingViewController: ViewControllable {
		loggedOutViewController.topViewControllable
	}
	var loggedOutViewController: ViewControllable {
		dependency.loggedOutViewController
	}
}
