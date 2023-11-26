import RIBs
import CorePresentation
import DesignKit
import OnBoarding

protocol DogProfileFirstSettingInteractable: Interactable, BirthdayPickerListener {
	var router: DogProfileFirstSettingRouting? { get set }
	var listener: DogProfileFirstSettingListener? { get set }
}

protocol DogProfileFirstSettingViewControllable: ViewControllable { }

final class DogProfileFirstSettingRouter:
	ViewableRouter<DogProfileFirstSettingInteractable, DogProfileFirstSettingViewControllable>,
	DogProfileFirstSettingRouting {
	private let birthdayPickerBuildable: BirthdayPickerBuildable
	private var birthdayPickerRouting: ViewableRouting?
	
	init(
		interactor: DogProfileFirstSettingInteractable,
		viewController: DogProfileFirstSettingViewControllable,
		birthdayPickerBuildable: BirthdayPickerBuildable
	) {
		self.birthdayPickerBuildable = birthdayPickerBuildable
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}

extension DogProfileFirstSettingRouter {
	func attachBirthdayPicker() {
		guard birthdayPickerRouting == nil else { return }
		let router = birthdayPickerBuildable.build(withListener: interactor)
		self.birthdayPickerRouting = router
		attachChild(router)
		viewControllable.present(router.viewControllable, animated: false, modalPresentationStyle: .overFullScreen)
	}
	
	func detachBirthdayPicker() {
		guard let router = birthdayPickerRouting else { return }
		detachChild(router)
		self.birthdayPickerRouting = nil
	}
}
