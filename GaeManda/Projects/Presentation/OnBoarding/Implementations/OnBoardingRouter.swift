import RIBs
import GMDUtils
import OnBoarding

protocol OnBoardingInteractable:
	Interactable,
	TermsOfUseListener,
	AddressSettingListener,
	DetailAddressSettingListener,
	UserSettingListener,
	DogSettingListener {
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
	
	private let addressSettingBuildable: AddressSettingBuildable
	private var addressSettingRouting: ViewableRouting?
	
	private let detailAddressSettingBuildable: DetailAddressSettingBuildable
	private var detailAddressSettingRouting: ViewableRouting?
	
	private let userSettingBuildable: UserSettingBuildable
	private var userSettingRouting: ViewableRouting?
	
	private let dogSettingBuildable: DogSettingBuildable
	private var dogSettingRouting: Routing?
	
	init(
		interactor: OnBoardingInteractable,
		viewController: ViewControllable,
		termsOfUseBuildable: TermsOfUseBuildable,
		addressSettingBuildable: AddressSettingBuildable,
		detailAddressSettingBuildable: DetailAddressSettingBuildable,
		userSettingBuildable: UserSettingBuildable,
		dogSettingBuildable: DogSettingBuildable
	) {
		self.viewController = viewController
		self.termsOfUseBuildable = termsOfUseBuildable
		self.addressSettingBuildable = addressSettingBuildable
		self.detailAddressSettingBuildable = detailAddressSettingBuildable
		self.userSettingBuildable = userSettingBuildable
		self.dogSettingBuildable = dogSettingBuildable
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

// MARK: - DetailAddressSetting
extension OnBoardingRouter {
	func detailAddressSettingAttach() {
		if detailAddressSettingRouting != nil { return }
		
		let router = detailAddressSettingBuildable.build(withListener: interactor)
		navigationControllerable?.present(router.viewControllable, animated: true)
		
		detailAddressSettingRouting = router
		attachChild(router)
	}
	
	func detailAddressSettingDetach() {
		guard let router = detailAddressSettingRouting else { return }
		
		navigationControllerable?.dismiss(completion: nil)
		detailAddressSettingRouting = nil
		detachChild(router)
	}
	
	func detailAddressSettingDismiss() {
		guard let router = detailAddressSettingRouting else { return }
		
		detailAddressSettingRouting = nil
		detachChild(router)
	}
}

// MARK: - UserSetting
extension OnBoardingRouter {
	func userSettingAttach() {
		if userSettingRouting != nil { return }
		
		let router = userSettingBuildable.build(withListener: interactor)
		navigationControllerable?.pushViewControllerable(router.viewControllable, animated: true)

		userSettingRouting = router
		attachChild(router)
	}

	func userSettingDetach() {
		guard let router = userSettingRouting else { return }
		
		navigationControllerable?.popViewControllerable(animated: true)
		userSettingRouting = nil
		detachChild(router)
	}
	
	func userSettingDismiss() {
		guard let router = userSettingRouting else { return }
		
		userSettingRouting = nil
		detachChild(router)
	}
}

// MARK: - DogSetting
extension OnBoardingRouter {
	func dogSettingAttach() {
		if dogSettingRouting != nil { return }
		
		let router = dogSettingBuildable.build(withListener: interactor)
		dogSettingRouting = router
		attachChild(router)
	}
	
	func dogSettingDetach() {
		guard let router = dogSettingRouting else { return }
		
		dogSettingRouting = nil
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
