import RIBs
import RxRelay
import CorePresentation
import OnBoarding

protocol DogProfileFirstSettingInteractable: Interactable, DogProfileFirstDashboardListener {
	var router: DogProfileFirstSettingRouting? { get set }
	var listener: DogProfileFirstSettingListener? { get set }
}

protocol DogProfileFirstSettingViewControllable: ViewControllable {
	func addDogProfileFirstDashboard(_ viewControllable: ViewControllable)
}

final class DogProfileFirstSettingRouter:
	ViewableRouter<DogProfileFirstSettingInteractable, DogProfileFirstSettingViewControllable>,
	DogProfileFirstSettingRouting {
	private let dogProfileFirstDashboardBuildable: DogProfileFirstDashboardBuildable
	private var dogProfileFirstDashboardRouting: ViewableRouting?
	
	init(
		interactor: DogProfileFirstSettingInteractable,
		viewController: DogProfileFirstSettingViewControllable,
		dogProfileFirstDashboardBuildable: DogProfileFirstDashboardBuildable
	) {
		self.dogProfileFirstDashboardBuildable = dogProfileFirstDashboardBuildable
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}

// MARK: - DogProfileFirstDashboard
extension DogProfileFirstSettingRouter {
	func dogProfileFirstDashboardAttach(
		nameTextFieldIsWarning: BehaviorRelay<Void>,
		birthdayTextFieldIsWarning: BehaviorRelay<Void>,
		weightTextFieldIsWarning: BehaviorRelay<Void>
	) {
		guard dogProfileFirstDashboardRouting == nil else { return }
		let router = dogProfileFirstDashboardBuildable.build(
			withListener: interactor,
			nameTextFieldIsWarning: nameTextFieldIsWarning,
			birthdayTextFieldIsWarning: birthdayTextFieldIsWarning,
			weightTextFieldIsWarning: weightTextFieldIsWarning,
			passingModel: nil
		)
		
		self.dogProfileFirstDashboardRouting = router
		attachChild(router)
		viewController.addDogProfileFirstDashboard(router.viewControllable)
	}
}
