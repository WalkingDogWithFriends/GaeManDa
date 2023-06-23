import RIBs
import OnBoarding
import Utils

protocol OnBoardingInteractable:
	Interactable,
	ProfileSettingListener {
	var router: OnBoardingRouting? { get set }
	var listener: OnBoardingListener? { get set }
}

protocol OnBoardingViewControllable: ViewControllable { }

final class OnBoardingRouter:
	Router<OnBoardingInteractable>,
	OnBoardingRouting {
	private let profileSettingBuildable: ProfileSettingBuildable
	private var profileSettingRouting: ViewableRouting?
	
	init(
		interactor: OnBoardingInteractable,
		viewController: ViewControllable,
		profileSettingBuildable: ProfileSettingBuildable
	) {
		self.viewController = viewController
		self.profileSettingBuildable = profileSettingBuildable
		super.init(interactor: interactor)
		interactor.router = self
	}
	
	func cleanupViews() {
		if let router = profileSettingRouting {
			detachChild(router)
		}
	}
	
	override func didLoad() {
		super.didLoad()
		profileSettingAttach()
	}
	
	func profileSettingAttach() {
		if profileSettingRouting != nil { return }
		
		let router = profileSettingBuildable.build(withListener: interactor)
		
		viewController.present(
			router.viewControllable,
			animated: true,
			modalPresentationStyle: .fullScreen
		)
		attachChild(router)
		profileSettingRouting = router
	}
	
	func profileSettingDetach() {
		guard let router = profileSettingRouting else { return }
		
		viewController.dismiss(completion: nil)
		profileSettingRouting = nil
		detachChild(router)
	}
	
	// MARK: - Private
	private let viewController: ViewControllable
}
