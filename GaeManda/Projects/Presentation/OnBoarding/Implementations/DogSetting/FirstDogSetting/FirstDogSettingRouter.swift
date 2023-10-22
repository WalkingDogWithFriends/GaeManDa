import RIBs
import OnBoarding

protocol FirstDogSettingInteractable: Interactable, BirthdayPickerListener {
	var router: FirstDogSettingRouting? { get set }
	var listener: FirstDogSettingListener? { get set }
}

protocol FirstDogSettingViewControllable: ViewControllable { }

final class FirstDogSettingRouter:
	ViewableRouter<FirstDogSettingInteractable, FirstDogSettingViewControllable>,
	FirstDogSettingRouting {
	private let birthdayPickerBuildable: BirthdayPickerBuildable
	private var birthdayPickerRouting: ViewableRouting?
	
	init(
		interactor: FirstDogSettingInteractable,
		viewController: FirstDogSettingViewControllable,
		birthdayPickerBuildable: BirthdayPickerBuildable
	) {
		self.birthdayPickerBuildable = birthdayPickerBuildable
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}

extension FirstDogSettingRouter {
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
