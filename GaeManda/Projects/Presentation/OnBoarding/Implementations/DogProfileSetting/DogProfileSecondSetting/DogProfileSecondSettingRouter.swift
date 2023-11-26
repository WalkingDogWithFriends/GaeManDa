import RIBs

protocol DogProfileSecondSettingInteractable: Interactable {
	var router: DogProfileSecondSettingRouting? { get set }
	var listener: DogProfileSecondSettingListener? { get set }
}

protocol DogProfileSecondSettingViewControllable: ViewControllable { }

final class DogProfileSecondSettingRouter:
	ViewableRouter<DogProfileSecondSettingInteractable, DogProfileSecondSettingViewControllable>,
	DogProfileSecondSettingRouting {
	override init(
		interactor: DogProfileSecondSettingInteractable,
		viewController: DogProfileSecondSettingViewControllable
	) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
