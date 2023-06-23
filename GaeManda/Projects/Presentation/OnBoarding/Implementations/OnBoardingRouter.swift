import RIBs
import OnBoarding
import Utils

protocol OnBoardingInteractable: Interactable {
	var router: OnBoardingRouting? { get set }
	var listener: OnBoardingListener? { get set }
}

protocol OnBoardingViewControllable: ViewControllable { }

final class OnBoardingRouter:
	Router<OnBoardingInteractable>,
	OnBoardingRouting {
	init(
		interactor: OnBoardingInteractable,
		viewController: ViewControllable
	) {
		self.viewController = viewController
		super.init(interactor: interactor)
		interactor.router = self
	}
	
	func cleanupViews() {	}
	
	override func didLoad() {
		super.didLoad()
	}

	private let viewController: ViewControllable
}
