import RIBs

protocol SecondDogSettingInteractable: Interactable {
	var router: SecondDogSettingRouting? { get set }
	var listener: SecondDogSettingListener? { get set }
}

protocol SecondDogSettingViewControllable: ViewControllable { }

final class SecondDogSettingRouter:
	ViewableRouter<SecondDogSettingInteractable, SecondDogSettingViewControllable>,
	SecondDogSettingRouting {
	override init(
		interactor: SecondDogSettingInteractable,
		viewController: SecondDogSettingViewControllable
	) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
