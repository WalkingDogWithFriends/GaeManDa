import RIBs
import OnBoarding
import Utils

protocol LoggedOutInteractable: Interactable {
	var router: LoggedOutRouting? { get set }
	var listener: LoggedOutListener? { get set }
}

protocol LoggedOutViewControllable: ViewControllable { }

final class LoggedOutRouter: Router<LoggedOutInteractable>, LoggedOutRouting {
	init(
		interactor: LoggedOutInteractable,
		viewController: ViewControllable
	) {
		self.viewController = viewController
		super.init(interactor: interactor)
		interactor.router = self
	}
	
	override func didLoad() {
		super.didLoad()
	}
	
	func cleanupViews() { }
	
	private let viewController: ViewControllable
}
