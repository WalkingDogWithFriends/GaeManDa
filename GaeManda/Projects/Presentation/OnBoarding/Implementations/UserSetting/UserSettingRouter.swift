import Foundation
import RIBs
import DesignKit
import OnBoarding

protocol UserSettingInteractable: Interactable, BirthdayPickerListener {
	var router: UserSettingRouting? { get set }
	var listener: UserSettingListener? { get set }
}

protocol UserSettingViewControllable: ViewControllable { }

final class ProfileSettingRouter:
	ViewableRouter<UserSettingInteractable, UserSettingViewControllable>,
	UserSettingRouting {
	private let birthdayPickerBuildable: BirthdayPickerBuildable
	private var birthdayPickerRouting: ViewableRouting?
	
	init(
		interactor: UserSettingInteractable,
		viewController: UserSettingViewControllable,
		birthdayPickerBuildable: BirthdayPickerBuildable
	) {
		self.birthdayPickerBuildable = birthdayPickerBuildable
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}

// MARK: - BirthdayPicker
extension ProfileSettingRouter: BirthdayPickerRouting {
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
