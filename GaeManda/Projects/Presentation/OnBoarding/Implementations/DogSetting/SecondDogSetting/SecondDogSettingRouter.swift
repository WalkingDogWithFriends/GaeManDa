import RIBs
import CorePresentation

protocol SecondDogSettingInteractable: Interactable, DogCharacterPickerListener {
	var router: SecondDogSettingRouting? { get set }
	var listener: SecondDogSettingListener? { get set }
}

protocol SecondDogSettingViewControllable: ViewControllable { }

final class SecondDogSettingRouter:
	ViewableRouter<SecondDogSettingInteractable, SecondDogSettingViewControllable>,
	SecondDogSettingRouting {
	private let dogCharacterPickerBuildable: DogCharacterPickerBuildable
	private var dogCharacterRouter: ViewableRouting?
	
	init(
		interactor: SecondDogSettingInteractable,
		viewController: SecondDogSettingViewControllable,
		dogCharacterPickerBuildable: DogCharacterPickerBuildable
	) {
		self.dogCharacterPickerBuildable = dogCharacterPickerBuildable
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
	
	func dogCharacterPickerAttach(with selectedId: [Int]) {
		if dogCharacterRouter != nil { return }
		
		let router = dogCharacterPickerBuildable.build(withListener: interactor, selectedId: selectedId)
		
		viewController.present(
			router.viewControllable,
			animated: false,
			modalPresentationStyle: .overFullScreen
		)
		
		self.dogCharacterRouter = router
		attachChild(router)
	}
	
	func dogCharacterPickerDetach() {
		guard let router = dogCharacterRouter else { return }
		
		detachChild(router)
		dogCharacterRouter = nil
	}
}
