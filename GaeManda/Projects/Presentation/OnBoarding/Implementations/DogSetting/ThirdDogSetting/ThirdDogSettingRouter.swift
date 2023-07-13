import RIBs

protocol ThirdDogSettingInteractable: Interactable {
	var router: ThirdDogSettingRouting? { get set }
	var listener: ThirdDogSettingListener? { get set }
}

protocol ThirdDogSettingViewControllable: ViewControllable { }

final class ThirdDogSettingRouter:
	ViewableRouter<ThirdDogSettingInteractable, ThirdDogSettingViewControllable>,
	ThirdDogSettingRouting {
	override init(
		interactor: ThirdDogSettingInteractable,
		viewController: ThirdDogSettingViewControllable
	) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
