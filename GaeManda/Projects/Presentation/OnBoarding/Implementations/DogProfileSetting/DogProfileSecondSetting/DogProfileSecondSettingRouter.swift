import RIBs
import CorePresentation
import Entity

protocol DogProfileSecondSettingInteractable: Interactable, DogCharacterPickerListener {
	var router: DogProfileSecondSettingRouting? { get set }
	var listener: DogProfileSecondSettingListener? { get set }
}

protocol DogProfileSecondSettingViewControllable: ViewControllable { }

final class DogProfileSecondSettingRouter:
	ViewableRouter<DogProfileSecondSettingInteractable, DogProfileSecondSettingViewControllable>,
	DogProfileSecondSettingRouting {
	private let dogCharacterPickerBuildable: DogCharacterPickerBuildable
	private var dogCharacterRouter: ViewableRouting?
	
	init(
		interactor: DogProfileSecondSettingInteractable,
		viewController: DogProfileSecondSettingViewControllable,
		dogCharacterPickerBuildable: DogCharacterPickerBuildable
	) {
		self.dogCharacterPickerBuildable = dogCharacterPickerBuildable
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
	
	func dogCharacterPickerAttach(characters: [DogCharacter], selectedId: [Int]) {
		if dogCharacterRouter != nil { return }
		
		let router = dogCharacterPickerBuildable.build(
			withListener: interactor,
			dogCharacters: characters,
			selectedId: selectedId
		)
		
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
