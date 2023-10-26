import RIBs
import GMDUtils
import OnBoarding

protocol AddressSettingInteractable: 
	Interactable,
	DetailAddressSettingListener {
	var router: AddressSettingRouting? { get set }
	var listener: AddressSettingListener? { get set }
}

protocol AddressSettingViewControllable: ViewControllable { }

final class AddressSettingRouter:
	ViewableRouter<AddressSettingInteractable, AddressSettingViewControllable>,
	AddressSettingRouting {
	private let detailAddressSettingBuildable: DetailAddressSettingBuildable
	private var detailAddressSettingRouting: ViewableRouting?
	
	init(
		interactor: AddressSettingInteractable,
		viewController: AddressSettingViewControllable,
		detailAddressSettingBuildable: DetailAddressSettingBuildable
	) {
		self.detailAddressSettingBuildable = detailAddressSettingBuildable
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}

extension AddressSettingRouter {
	func detailAddressSettingAttach() {
		if detailAddressSettingRouting != nil { return }
		
		let router = detailAddressSettingBuildable.build(withListener: interactor)
        viewControllable.present(router.viewControllable, animated: true)
		
		detailAddressSettingRouting = router
		attachChild(router)
	}
	
	func detailAddressSettingDetach() {
		guard let router = detailAddressSettingRouting else { return }
		
		viewControllable.dismiss(completion: nil)
		detailAddressSettingRouting = nil
		detachChild(router)
	}
	
	func detailAddressSettingDismiss() {
		guard let router = detailAddressSettingRouting else { return }
        
        viewControllable.dismiss(completion: nil)
		detailAddressSettingRouting = nil
		detachChild(router)
	}
}
