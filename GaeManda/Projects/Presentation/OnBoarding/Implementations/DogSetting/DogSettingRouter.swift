import RIBs
import GMDUtils
import OnBoarding

protocol DogSettingInteractable:
	Interactable,
	FirstDogSettingListener,
	SecondDogSettingListener {
	var router: DogSettingRouting? { get set }
	var listener: DogSettingListener? { get set }
}

protocol DogSettingViewControllable: ViewControllable { }

final class DogSettingRouter:
	Router<DogSettingInteractable>,
	DogSettingRouting {
	private let firstDogSettingBuildable: FirstDogSettingBuildable
	private var firstDogSettingRouting: ViewableRouting?
	
	private let secondDogSettingBuildable: SecondDogSettingBuildable
	private var secondDogSettingRouting: ViewableRouting?
	
	init(
		interactor: DogSettingInteractable,
		viewController: ViewControllable,
		firstDogSettingBuildable: FirstDogSettingBuildable,
		secondDogSettingBuildable: SecondDogSettingBuildable
	) {
		self.viewController = viewController
		self.firstDogSettingBuildable = firstDogSettingBuildable
		self.secondDogSettingBuildable = secondDogSettingBuildable
		super.init(interactor: interactor)
		interactor.router = self
	}
	
	override func didLoad() {
		super.didLoad()
		firstDogSettingAttach()
	}
	
	func cleanupViews() {
		if secondDogSettingRouting != nil {
			viewController.popViewController(animated: true)
		}
		if firstDogSettingRouting != nil {
			viewController.popViewController(animated: true)
		}
	}
	
	private let viewController: ViewControllable
}

// MARK: FirstDogSetting
extension DogSettingRouter {
	func firstDogSettingAttach() {
		if firstDogSettingRouting != nil { return }
		
		let router = firstDogSettingBuildable.build(withListener: interactor)
		viewController.pushViewController(
			router.viewControllable,
			animated: true
		)
		firstDogSettingRouting = router
		attachChild(router)
	}
	
	func firstDogSettingDetach() {
		guard let router = firstDogSettingRouting else { return }
		
		viewController.popViewController(animated: true)
		firstDogSettingRouting = nil
		detachChild(router)
	}
	
	func firstDogSettingDismiss() {
		guard let router = firstDogSettingRouting else { return }
		
		firstDogSettingRouting = nil
		detachChild(router)
	}
	
	func firstDogSettingDidFinish() {
		secondDogSettingAttach()
	}
}

// MARK: SecondDogSetting
extension DogSettingRouter {
	func secondDogSettingAttach() {
		if secondDogSettingRouting != nil { return }
		
		let router = secondDogSettingBuildable.build(withListener: interactor)
		viewController.pushViewController(
			router.viewControllable,
			animated: true
		)
		secondDogSettingRouting = router
		attachChild(router)
	}
	
	func secondDogSettingDetach() {
		guard let router = secondDogSettingRouting else { return }
		
		viewController.popViewController(animated: true)
		secondDogSettingRouting = nil
		detachChild(router)
	}
	
	func secondDogSettingDismiss() {
		guard let router = secondDogSettingRouting else { return }
		
		secondDogSettingRouting = nil
		detachChild(router)
	}
}
