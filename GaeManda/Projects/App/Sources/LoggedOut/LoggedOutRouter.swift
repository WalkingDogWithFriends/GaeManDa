import RIBs
import OnBoarding
import Utils

protocol LoggedOutInteractable:
	Interactable,
	OnBoardingListener {
	var router: LoggedOutRouting? { get set }
	var listener: LoggedOutListener? { get set }
}

protocol LoggedOutViewControllable: ViewControllable { }

final class LoggedOutRouter: Router<LoggedOutInteractable>, LoggedOutRouting {
	private let onBoardingBuildable: OnBoardingBuildable
	private var onBoardingRouting: Routing?
	
	init(
		interactor: LoggedOutInteractable,
		viewController: ViewControllable,
		onBoardingBuildable: OnBoardingBuildable
	) {
		self.viewController = viewController
		self.onBoardingBuildable = onBoardingBuildable
		super.init(interactor: interactor)
		interactor.router = self
	}
	
	override func didLoad() {
		super.didLoad()
		attachOnBoarding()
	}
	
	func cleanupViews() {
		if let routing = onBoardingRouting {
			detachChild(routing)
		}
	}
	
	func attachOnBoarding() {
		if onBoardingRouting != nil { return }
		
		let router = onBoardingBuildable.build(withListener: interactor)
		onBoardingRouting = router
		attachChild(router)
	}
	
	func detachOnBoarding() {
		guard let router = onBoardingRouting else { return }
		
		onBoardingRouting = nil
		detachChild(router)
	}
	
	private let viewController: ViewControllable
}
