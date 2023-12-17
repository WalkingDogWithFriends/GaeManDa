import RIBs
import RxCocoa
import CorePresentation
import Entity

protocol DogProfileSecondSettingInteractable:
	Interactable,
	DogProfileSecondDashboardListener,
	DogCharacterPickerListener,
	DogCharacterDashboardListener {
	var router: DogProfileSecondSettingRouting? { get set }
	var listener: DogProfileSecondSettingListener? { get set }
}

protocol DogProfileSecondSettingViewControllable: ViewControllable {
	func addDashboard(_ viewControllable: ViewControllable)
}

final class DogProfileSecondSettingRouter:
	ViewableRouter<DogProfileSecondSettingInteractable, DogProfileSecondSettingViewControllable>,
	DogProfileSecondSettingRouting {
	private let dogProfileSecondDashboardBuildable: DogProfileSecondDashboardBuildable
	private var dogProfileSecondDashboardRouting: ViewableRouting?
	
	private let dogCharacterPickerBuildable: DogCharacterPickerBuildable
	private var dogCharacterRouter: ViewableRouting?
	
	private let dogCharacterDashboardBuildable: DogCharacterDashboardBuildable
	private var dogCharacterDashboardRouter: ViewableRouting?
	
	init(
		interactor: DogProfileSecondSettingInteractable,
		viewController: DogProfileSecondSettingViewControllable,
		dogProfileSecondDashboardBuildable: DogProfileSecondDashboardBuildable,
		dogCharacterPickerBuildable: DogCharacterPickerBuildable,
		dogCharacterDashboardBuilder: DogCharacterDashboardBuildable
	) {
		self.dogProfileSecondDashboardBuildable = dogProfileSecondDashboardBuildable
		self.dogCharacterPickerBuildable = dogCharacterPickerBuildable
		self.dogCharacterDashboardBuildable = dogCharacterDashboardBuilder
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}

// MARK: - DogProfileSecondDashboard
extension DogProfileSecondSettingRouter {
	func dogProfileSecondDashboardAttach(dogSpecies: [String]) {
		if dogProfileSecondDashboardRouting != nil { return }
		
		let router = dogProfileSecondDashboardBuildable.build(
			withListener: interactor,
			dogSpecies: dogSpecies,
			selectedDogSpecies: nil,
			isNeutered: nil
		)
		
		self.dogProfileSecondDashboardRouting = router
		attachChild(router)
		viewController.addDashboard(router.viewControllable)
	}
}

// MARK: - DogCharacterDashBoard
extension DogProfileSecondSettingRouter {
	func dogCharacterDashboardAttach(selectedCharacters: BehaviorRelay<[DogCharacter]>) {
		if dogCharacterDashboardRouter != nil { return }
		
		let router = dogCharacterDashboardBuildable.build(withListener: interactor, selectedCharacters: selectedCharacters)
		
		viewController.addDashboard(router.viewControllable)
		dogCharacterDashboardRouter = router
		attachChild(router)
	}
}

// MARK: - DogCharacterPicker
extension DogProfileSecondSettingRouter {
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
