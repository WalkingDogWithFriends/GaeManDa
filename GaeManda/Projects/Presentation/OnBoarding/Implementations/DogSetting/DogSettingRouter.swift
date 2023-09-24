import RIBs
import GMDUtils
import OnBoarding

protocol DogSettingInteractable:
	Interactable,
	FirstDogSettingListener,
	SecondDogSettingListener,
	ThirdDogSettingListener {
	var router: DogSettingRouting? { get set }
	var listener: DogSettingListener? { get set }
}

protocol DogSettingViewControllable: ViewControllable { }

final class DogSettingRouter:
	Router<DogSettingInteractable>,
	DogSettingRouting {
	private var navigationControllable: NavigationControllerable?
	
	private let firstDogSettingBuildable: FirstDogSettingBuildable
	private var firstDogSettingRouting: ViewableRouting?
	
	private let secondDogSettingBuildable: SecondDogSettingBuildable
	private var secondDogSettingRouting: ViewableRouting?
	
	private let thirdDogSettingBuildable: ThirdDogSettingBuildable
	private var thirdDogSettingRouting: ViewableRouting?
	
	init(
		interactor: DogSettingInteractable,
		viewController: ViewControllable,
		navigationControllable: NavigationControllerable?,
		firstDogSettingBuildable: FirstDogSettingBuildable,
		secondDogSettingBuildable: SecondDogSettingBuildable,
		thirdDogSettingBuildable: ThirdDogSettingBuildable
	) {
		self.viewController = viewController
		self.navigationControllable = navigationControllable
		self.firstDogSettingBuildable = firstDogSettingBuildable
		self.secondDogSettingBuildable = secondDogSettingBuildable
		self.thirdDogSettingBuildable = thirdDogSettingBuildable
		super.init(interactor: interactor)
		interactor.router = self
	}
	
	override func didLoad() {
		super.didLoad()
		firstDogSettingAttach()
	}
	
	func cleanupViews() {
		if thirdDogSettingRouting != nil {
			navigationControllable?.popViewController(animated: true)
		}
		if secondDogSettingRouting != nil {
			navigationControllable?.popViewController(animated: true)
		}
		if firstDogSettingRouting != nil {
			navigationControllable?.popViewController(animated: true)
		}
	}
	
	private let viewController: ViewControllable
}

// MARK: FirstDogSetting
extension DogSettingRouter {
	func firstDogSettingAttach() {
		if firstDogSettingRouting != nil { return }
		
		let router = firstDogSettingBuildable.build(withListener: interactor)
		navigationControllable?.pushViewController(
			router.viewControllable,
			animated: true
		)
		firstDogSettingRouting = router
		attachChild(router)
	}
	
	func firstDogSettingDetach() {
		guard let router = firstDogSettingRouting else { return }
		
		navigationControllable?.popViewController(animated: true)
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
		navigationControllable?.pushViewController(
			router.viewControllable,
			animated: true
		)
		secondDogSettingRouting = router
		attachChild(router)
	}
	
	func secondDogSettingDetach() {
		guard let router = secondDogSettingRouting else { return }
		
		navigationControllable?.popViewController(animated: true)
		secondDogSettingRouting = nil
		detachChild(router)
	}
	
	func secondDogSettingDismiss() {
		guard let router = secondDogSettingRouting else { return }
		
		secondDogSettingRouting = nil
		detachChild(router)
	}
	
	func secondDogSettingDidFinish() {
		thirdDogSettingAttach()
	}
}

// MARK: ThirdDogSetting
extension DogSettingRouter {
	func thirdDogSettingAttach() {
		if thirdDogSettingRouting != nil { return }
		
		let router = thirdDogSettingBuildable.build(withListener: interactor)
		navigationControllable?.pushViewController(
			router.viewControllable,
			animated: true
		)
		thirdDogSettingRouting = router
		attachChild(router)
	}
	
	func thirdDogSettingDetach() {
		guard let router = thirdDogSettingRouting else { return }
		
		navigationControllable?.popViewController(animated: true)
		thirdDogSettingRouting = nil
		detachChild(router)
	}
	
	func thirdDogSettingDismiss() {
		guard let router = thirdDogSettingRouting else { return }
		
		thirdDogSettingRouting = nil
		detachChild(router)
	}
}
