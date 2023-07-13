import RIBs

protocol FirstDogSettingInteractable: Interactable {
	var router: FirstDogSettingRouting? { get set }
	var listener: FirstDogSettingListener? { get set }
}

protocol FirstDogSettingViewControllable: ViewControllable { }

final class FirstDogSettingRouter:
	ViewableRouter<FirstDogSettingInteractable, FirstDogSettingViewControllable>,
	FirstDogSettingRouting {
	override init(
		interactor: FirstDogSettingInteractable,
		viewController: FirstDogSettingViewControllable
	) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
