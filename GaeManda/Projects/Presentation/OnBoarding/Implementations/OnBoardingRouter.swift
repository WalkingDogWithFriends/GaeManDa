import RIBs
import GMDUtils
import OnBoarding

protocol OnBoardingInteractable:
	Interactable,
	TermsOfUseListener,
	AddressSettingListener,
	UserProfileSettingListener,
	DogProfileSettingListener {
	var router: OnBoardingRouting? { get set }
	var listener: OnBoardingListener? { get set }
}

final class OnBoardingRouter:
	Router<OnBoardingInteractable>,
	OnBoardingRouting {
	private var navigationControllerable: NavigationControllerable?
	
	private let termsOfUseBuildable: TermsOfUseBuildable
	private var termsOfUseRouting: ViewableRouting?
	
	private let addressSettingBuildable: AddressSettingBuildable
	private var addressSettingRouting: ViewableRouting?
	
	private let userProfileSettingBuildable: UserProfileSettingBuildable
	private var userProfileSettingRouting: ViewableRouting?
	
	private let dogProfileSettingBuildable: DogProfileSettingBuildable
	private var dogProfileSettingRouting: Routing?
	
	init(
		interactor: OnBoardingInteractable,
		viewController: ViewControllable,
		termsOfUseBuildable: TermsOfUseBuildable,
		addressSettingBuildable: AddressSettingBuildable,
		userProfileSettingBuildable: UserProfileSettingBuildable,
		dogProfileSettingBuildable: DogProfileSettingBuildable
	) {
		self.viewController = viewController
		self.termsOfUseBuildable = termsOfUseBuildable
		self.addressSettingBuildable = addressSettingBuildable
		self.userProfileSettingBuildable = userProfileSettingBuildable
		self.dogProfileSettingBuildable = dogProfileSettingBuildable
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

// MARK: - TermsOfUse
extension OnBoardingRouter {
	func termsOfUseAttach() {
		if termsOfUseRouting != nil { return }
		
		let router = termsOfUseBuildable.build(withListener: interactor)
		presentInsideNavigation(router.viewControllable)
		
		termsOfUseRouting = router
		attachChild(router)
	}
	
	func termsOfUseDetach() {
		guard let router = termsOfUseRouting else { return }

		dismissPresentedNavigation(completion: nil)
		termsOfUseRouting = nil
		detachChild(router)
	}
}

// MARK: - AddressSetting
extension OnBoardingRouter {
	func addressSettingAttach() {
		if addressSettingRouting != nil { return }
		
		let router = addressSettingBuildable.build(withListener: interactor)
		navigationControllerable?.pushViewControllerable(router.viewControllable, animated: true)
		
		addressSettingRouting = router
		attachChild(router)
	}
	
	func addressSettingDetach() {
		guard let router = addressSettingRouting else { return }
		
		navigationControllerable?.popViewControllerable(animated: true)
		addressSettingRouting = nil
		detachChild(router)
	}
	
	func addressSettingDismiss() {
		guard let router = addressSettingRouting else { return }
		
		addressSettingRouting = nil
		detachChild(router)
	}
}

// MARK: UserProfileSetting
extension OnBoardingRouter {
	func userProfileSettingAttach() {
		if userProfileSettingRouting != nil { return }
		
		let router = userProfileSettingBuildable.build(withListener: interactor)
		navigationControllerable?.pushViewControllerable(router.viewControllable, animated: true)

		userProfileSettingRouting = router
		attachChild(router)
	}

	func userProfileSettingDetach() {
		guard let router = userProfileSettingRouting else { return }
		
		navigationControllerable?.popViewControllerable(animated: true)
		userProfileSettingRouting = nil
		detachChild(router)
	}
	
	func userProfileSettingDismiss() {
		guard let router = userProfileSettingRouting else { return }
		
		userProfileSettingRouting = nil
		detachChild(router)
	}
}

// MARK: - DogProfileSetting
extension OnBoardingRouter {
	func dogProfileSettingAttach() {
		if dogProfileSettingRouting != nil { return }
		
		let router = dogProfileSettingBuildable.build(withListener: interactor)
		dogProfileSettingRouting = router
		attachChild(router)
	}
	
	func dogProfileSettingDetach() {
		guard let router = dogProfileSettingRouting else { return }
		
		dogProfileSettingRouting = nil
		detachChild(router)
	}
}
	
// MARK: - NavigationControllable Extension
private extension OnBoardingRouter {
	func presentInsideNavigation(_ viewControllable: ViewControllable) {
		if let navigation = navigationControllerable {
			navigation.setViewControllers([viewControllable])
		} else {
			createNavigation(viewControllable)
		}
	}
	
	func createNavigation(_ viewControllable: ViewControllable) {
		let navigation = NavigationControllerable(root: viewControllable)
		self.navigationControllerable = navigation
		viewController.present(
			navigation,
			animated: true,
			modalPresentationStyle: .fullScreen
		)
	}
	
	func dismissPresentedNavigation(completion: (() -> Void)?) {
		if self.navigationControllerable == nil { return }
		
		viewController.dismiss(completion: nil)
		self.navigationControllerable = nil
	}
}
