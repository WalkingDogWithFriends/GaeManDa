import RIBs
import GMDUtils
import OnBoarding

protocol DogProfileSettingInteractable:
	Interactable,
	DogProfileFirstSettingListener,
	DogProfileSecondSettingListener {
	var router: DogProfileSettingRouting? { get set }
	var listener: DogProfileSettingListener? { get set }
}

protocol DogProfileSettingViewControllable: ViewControllable { }

final class DogProfileSettingRouter:
	Router<DogProfileSettingInteractable>,
	DogProfileSettingRouting {
	private let dogProfileFirstSettingBuildable: DogProfileFirstSettingBuildable
	private var dogProfileFirstSettingRouting: ViewableRouting?
	
	private let dogProfileSecondSettingBuildable: DogProfileSecondSettingBuildable
	private var dogProfileSecondSettingRouting: ViewableRouting?
	
	init(
		interactor: DogProfileSettingInteractable,
		viewController: ViewControllable,
		dogProfileFirstSettingBuildable: DogProfileFirstSettingBuildable,
		dogProfileSecondSettingBuildable: DogProfileSecondSettingBuildable
	) {
		self.viewController = viewController
		self.dogProfileFirstSettingBuildable = dogProfileFirstSettingBuildable
		self.dogProfileSecondSettingBuildable = dogProfileSecondSettingBuildable
		super.init(interactor: interactor)
		interactor.router = self
	}
	
	override func didLoad() {
		super.didLoad()
		dogProfileFirstSettingAttach()
	}
	
	func cleanupViews() {
		if dogProfileSecondSettingRouting != nil {
			viewController.popViewController(animated: true)
		}
		if dogProfileFirstSettingRouting != nil {
			viewController.popViewController(animated: true)
		}
	}
	
	private let viewController: ViewControllable
}

// MARK: DogProfileFirstSetting
extension DogProfileSettingRouter {
	func dogProfileFirstSettingAttach() {
		if dogProfileFirstSettingRouting != nil { return }
		
		let router = dogProfileFirstSettingBuildable.build(withListener: interactor)
		viewController.pushViewController(
			router.viewControllable,
			animated: true
		)
		dogProfileFirstSettingRouting = router
		attachChild(router)
	}
	
	func dogProfileFirstSettingDetach() {
		guard let router = dogProfileFirstSettingRouting else { return }
		
		viewController.popViewController(animated: true)
		dogProfileFirstSettingRouting = nil
		detachChild(router)
	}
	
	func dogProfileFirstSettingDismiss() {
		guard let router = dogProfileFirstSettingRouting else { return }
		
		dogProfileFirstSettingRouting = nil
		detachChild(router)
	}
}

// MARK: DogProfileSecondSetting
extension DogProfileSettingRouter {
	func dogProfileSecondSettingAttach() {
		if dogProfileSecondSettingRouting != nil { return }
		
		let router = dogProfileSecondSettingBuildable.build(withListener: interactor)
		viewController.pushViewController(
			router.viewControllable,
			animated: true
		)
		dogProfileSecondSettingRouting = router
		attachChild(router)
	}
	
	func dogProfileSecondSettingDetach() {
		guard let router = dogProfileSecondSettingRouting else { return }
		
		viewController.popViewController(animated: true)
		dogProfileSecondSettingRouting = nil
		detachChild(router)
	}
	
	func dogProfileSecondSettingDismiss() {
		guard let router = dogProfileSecondSettingRouting else { return }
		
		dogProfileSecondSettingRouting = nil
		detachChild(router)
	}
}
