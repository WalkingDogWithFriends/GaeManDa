import RIBs
import GMDUtils
import OnBoarding
import SignIn

protocol LoggedOutInteractable:
	Interactable,
	SignInListener,
	OnBoardingListener {
	var router: LoggedOutRouting? { get set }
	var listener: LoggedOutListener? { get set }
}

protocol LoggedOutViewControllable: ViewControllable { }

final class LoggedOutRouter: Router<LoggedOutInteractable>, LoggedOutRouting {
	private let onBoardingBuildable: OnBoardingBuildable
	private var onBoardingRouting: Routing?
	
	private let signInBuildable: SignInBuildable
	private var signInRouting: ViewableRouting?
	
	init(
		interactor: LoggedOutInteractable,
		viewController: ViewControllable,
		signInBuildable: SignInBuildable,
		onBoardingBuildable: OnBoardingBuildable
	) {
		self.viewController = viewController
		self.onBoardingBuildable = onBoardingBuildable
		self.signInBuildable = signInBuildable
		super.init(interactor: interactor)
		interactor.router = self
	}
	
	override func didLoad() {
		super.didLoad()
		attachSignIn()
	}
	
	func cleanupViews() {
		if let routing = onBoardingRouting {
			detachChild(routing)
		}
	}
	
	private let viewController: ViewControllable
}

// MARK: - SignIn
extension LoggedOutRouter {
	func attachSignIn() {
		if signInRouting != nil { return }
		
		let router = signInBuildable.build(withListener: interactor)
		viewController.present(
			router.viewControllable,
			animated: true,
			modalPresentationStyle: .fullScreen
		)

		signInRouting = router
		attachChild(router)
	}
	
	func detachSignIn() {
		guard let router = signInRouting else { return }
		signInRouting = nil
		detachChild(router)
		viewController.dismiss(animated: false)
	}
}

// MARK: - OnBoarding
extension LoggedOutRouter {
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
}
