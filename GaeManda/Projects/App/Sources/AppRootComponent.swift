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
	
	// MARK: - UseCase
	lazy var gmdProfileUseCase: GMDProfileUseCase = {
		return GMDProfileUseCaseImpl(
			dogDependecy: dogRepository,
			userDependency: userRepository
		)
	}()
	
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
