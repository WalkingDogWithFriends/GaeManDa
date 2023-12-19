import RIBs
import DataMapper
import GMDNetwork
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
		self.appUseCase = AppUseCaseImpl(appRepository: appRepository)
		super.init(dependency: EmptyComponent())
	}
}
