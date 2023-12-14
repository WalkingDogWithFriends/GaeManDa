import RIBs
import RxCocoa
import CorePresentation
import Entity

protocol DogProfileSecondSettingInteractable: Interactable, DogCharacterPickerListener, DogCharacterDashboardListener {
	var router: DogProfileSecondSettingRouting? { get set }
	var listener: DogProfileSecondSettingListener? { get set }
}

protocol DogProfileSecondSettingViewControllable: ViewControllable { 
	func addDogCharacterDashboard(_ viewControllable: ViewControllable)
}

final class DogProfileSecondSettingRouter:
	ViewableRouter<DogProfileSecondSettingInteractable, DogProfileSecondSettingViewControllable>,
	DogProfileSecondSettingRouting {
	private let dogCharacterPickerBuildable: DogCharacterPickerBuildable
	private var dogCharacterRouter: ViewableRouting?
	
	private let dogCharacterDashboardBuildable: DogCharacterDashboardBuildable
	private var dogCharacterDashboardRouter: ViewableRouting?

	init(
		interactor: DogProfileSecondSettingInteractable,
		viewController: DogProfileSecondSettingViewControllable,
		dogCharacterPickerBuildable: DogCharacterPickerBuildable,
		dogCharacterDashboardBuilder: DogCharacterDashboardBuildable
	) {
		self.dogCharacterPickerBuildable = dogCharacterPickerBuildable
		self.dogCharacterDashboardBuildable = dogCharacterDashboardBuilder
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

// MARK: - DogCharacterDashBoard
extension DogProfileSecondSettingRouter {
	func dogCharacterDashboardAttach(selectedCharacters: BehaviorRelay<[DogCharacter]>) {
		if dogCharacterDashboardRouter != nil { return }
		
		let router = dogCharacterDashboardBuildable.build(withListener: interactor, selectedCharacters: selectedCharacters)
		
		viewController.addDogCharacterDashboard(router.viewControllable)
		dogCharacterDashboardRouter = router
		attachChild(router)
	}
}
