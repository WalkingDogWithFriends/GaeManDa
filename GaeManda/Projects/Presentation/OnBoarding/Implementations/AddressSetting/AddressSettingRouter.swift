import RIBs

protocol AddressSettingInteractable: Interactable {
	var router: AddressSettingRouting? { get set }
	var listener: AddressSettingListener? { get set }
}

protocol AddressSettingViewControllable: ViewControllable { }

final class AddressSettingRouter:
	ViewableRouter<AddressSettingInteractable, AddressSettingViewControllable>,
	AddressSettingRouting {
	override init(
		interactor: AddressSettingInteractable,
		viewController: AddressSettingViewControllable
	) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
