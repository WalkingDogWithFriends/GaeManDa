import RIBs
import OnBoarding
import Utils

protocol OnBoardingInteractable:
	Interactable,
	ProfileSettingListener,
	TermsOfUseListener {
	var router: OnBoardingRouting? { get set }
	var listener: OnBoardingListener? { get set }
}

protocol OnBoardingViewControllable: ViewControllable { }

final class OnBoardingRouter:
	Router<OnBoardingInteractable>,
	OnBoardingRouting {
	private var navigationControllerable: NavigationControllerable?
	
	private let termsOfUseBuildable: TermsOfUseBuildable
	private var termsOfUseRouting: ViewableRouting?
	
	private let profileSettingBuildable: ProfileSettingBuildable
	private var profileSettingRouting: ViewableRouting?
	
	init(
		interactor: OnBoardingInteractable,
		viewController: ViewControllable,
		termsOfUseBuildable: TermsOfUseBuildable,
		profileSettingBuildable: ProfileSettingBuildable
	) {
		self.viewController = viewController
		self.termsOfUseBuildable = termsOfUseBuildable
		self.profileSettingBuildable = profileSettingBuildable
		super.init(interactor: interactor)
		interactor.router = self
	}
	
	func cleanupViews() {
		if
			viewController.uiviewController.presentedViewController != nil,
			navigationControllerable != nil {
			navigationControllerable?.dismiss(completion: nil)
		}
	}
	
	override func didLoad() {
		super.didLoad()
		termsOfUseAttach()
	}
	
	private let viewController: ViewControllable
}

// MARK: TermsOfUse
extension OnBoardingRouter {
	func termsOfUseAttach() {
		if termsOfUseRouting != nil { return }
		
		let router = termsOfUseBuildable.build(withListener: interactor)
		presentInsideNavigation(router.viewControllable)
		
		attachChild(router)
		termsOfUseRouting = router
	}
	
	func termsOfUseDetach() {
		guard let router = termsOfUseRouting else { return }
		
		dismissPresentedNavigation(completion: nil)
		termsOfUseRouting = nil
		detachChild(router)
	}
	
	func termsOfUseDidFinish() {
		print("termsOfUseDidFinish")
	}
}

// MARK: ProfileSetting
extension OnBoardingRouter {
	func profileSettingAttach() {
		if profileSettingRouting != nil { return }
		
		let router = profileSettingBuildable.build(withListener: interactor)
		presentInsideNavigation(router.viewControllable)
		
		attachChild(router)
		profileSettingRouting = router
	}
	
	func profileSettingDetach() {
		guard let router = profileSettingRouting else { return }
		
		dismissPresentedNavigation(completion: nil)
		profileSettingRouting = nil
		detachChild(router)
	}
}

// MARK: NavigationControllable Extension
private extension OnBoardingRouter {
	private func presentInsideNavigation(_ viewControllable: ViewControllable) {
		if let navigation = navigationControllerable {
			navigation.setViewControllers([viewControllable])
		} else {
			createNavigation(viewControllable)
		}
	}
	
	private func createNavigation(_ viewControllable: ViewControllable) {
		let navigation = NavigationControllerable(root: viewControllable)
		navigation.navigationBarIsHidden = true
		self.navigationControllerable = navigation
		viewController.present(
			navigation,
			animated: true,
			modalPresentationStyle: .fullScreen
		)
	}
	
	private func dismissPresentedNavigation(completion: (() -> Void)?) {
		if self.navigationControllerable == nil { return }
		
		viewController.dismiss(completion: nil)
		self.navigationControllerable = nil
	}
}
