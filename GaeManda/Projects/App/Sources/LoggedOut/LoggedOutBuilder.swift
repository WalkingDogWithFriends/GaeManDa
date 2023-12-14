import RIBs
import CorePresentation
import DesignKit
import Repository
import UseCase

protocol LoggedOutDependency: Dependency {
	var birthdayPickerBuildable: BirthdayPickerBuildable { get }
	var dogCharacterPickerBuildable: DogCharacterPickerBuildable { get }
	var dogCharacterDashboardBuildable: DogCharacterDashboardBuildable { get }
	var loggedOutViewController: ViewControllable { get }
	var dogRepository: DogRepository { get }
	var userRepository: UserRepository { get }
	var signInUseCase: SignInUseCase { get }
}

protocol LoggedOutBuildable: Buildable {
	func build(withListener listener: LoggedOutListener) -> Routing
}

final class LoggedOutBuilder:
	Builder<LoggedOutDependency>,
	LoggedOutBuildable {
	override init(dependency: LoggedOutDependency) {
		super.init(dependency: dependency)
	}
	
	func build(withListener listener: LoggedOutListener) -> Routing {
		let component = LoggedOutComponent(dependency: dependency)
		let interactor = LoggedOutInteractor(signInUseCase: component.signInUseCase)
		interactor.listener = listener
		
		return LoggedOutRouter(
			interactor: interactor,
			viewController: component.loggedOutViewController,
			signInBuildable: component.signInBuildable,
			onBoardingBuildable: component.onBoardingBuildable
		)
	}
}
