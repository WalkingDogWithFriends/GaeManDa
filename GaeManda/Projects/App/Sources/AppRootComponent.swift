import RIBs
import CorePresentation
import CorePresentationImpl
import DataMapper
import DesignKit
import GMDUtils
import UseCase
import UseCaseImpl
import Repository
import RepositoryImpl

final class AppRootComponent:
	Component<AppRootDependency>,
	LoggedOutDependency,
	LoggedInDependency,
	BirthdayPickerDependency,
	DogCharacterPickerDependency {
	lazy var dogCharacterPickerBuildable: DogCharacterPickerBuildable = {
		return DogCharacterPickerBuilder(dependency: self)
	}()
	
	lazy var birthdayPickerBuildable: BirthdayPickerBuildable = {
		return BirthdayPickerBuilder(dependency: self)
	}()
	
	lazy var loggedOutBuildable: LoggedOutBuildable = {
		return LoggedOutBuilder(dependency: self)
	}()
	
	// MARK: - Repository
	lazy var dogRepository: DogRepository = {
		return DogRepositoryImpl(dogDataMapper: DogDataMapperImpl())
	}()
	
	lazy var userRepository: UserRepository = {
		return UserRepositoryImpl(userDataMapper: UserProfileDataMapperImpl())
	}()
	
	var signInRepository = SignInRepositoryImpl(keychainStorage: .shared)
	
	// MARK: - UseCase
	lazy var gmdProfileUseCase: GMDProfileUseCase = {
		return GMDProfileUseCaseImpl(
			dogRepository: dogRepository,
			userRepository: userRepository
		)
	}()
	
	var signInUseCase: SignInUseCase {
		return SignInUseCaseImpl(signinRespository: signInRepository)
	}
	
	var loggedOutViewController: ViewControllable { rootViewController }
	
	private let rootViewController: ViewControllable
	
	init(
		dependency: AppRootDependency,
		rootViewController: ViewControllable
	) {
		self.rootViewController = rootViewController
		super.init(dependency: dependency)
	}
}
