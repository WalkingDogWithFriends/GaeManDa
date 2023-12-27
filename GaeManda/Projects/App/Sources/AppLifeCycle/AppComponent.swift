import RIBs
import DataMapper
import GMDNetwork
import GMDUtils
import UseCase
import UseCaseImpl
import Repository
import RepositoryImpl
import LocalStorage

final class AppComponent: Component<EmptyComponent>, AppRootDependency {
	let appDataMapper: AppDataMapper
	let requestInterceptor: Interceptor
	let session: Session
	let keychainStorage: KeyChainStorage
	let locationManagable: CLLocationManagable
	
	// MARK: - Repository
	let appRepository: AppRepository
	
	// MARK: - Repository
	let appUseCase: AppUseCase
	
	init() {
		self.appDataMapper = AppDataMapperImpl()
		self.requestInterceptor = RequesetInterceptor()
		self.session = Session(session: .init(configuration: .default), interceptor: requestInterceptor)
		self.keychainStorage = .shared
		self.appRepository = AppRepositoryImpl(
			dataMapper: appDataMapper,
			session: session,
			keychainStorage: keychainStorage
		)
		self.locationManagable = CLLocationManagerProxy()
		self.appUseCase = AppUseCaseImpl(appRepository: appRepository, locationManagable: locationManagable)
		super.init(dependency: EmptyComponent())
	}
}
