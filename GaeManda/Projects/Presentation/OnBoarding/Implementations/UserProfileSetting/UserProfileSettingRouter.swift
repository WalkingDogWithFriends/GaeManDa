import Foundation
import RIBs
import CorePresentation
import DesignKit
import OnBoarding

protocol UserProfileSettingInteractable: Interactable, BirthdayPickerListener {
	var router: UserProfileSettingRouting? { get set }
	var listener: UserProfileSettingListener? { get set }
}

protocol UserProfileSettingViewControllable: ViewControllable { }

final class ProfileSettingRouter:
	ViewableRouter<UserProfileSettingInteractable, UserProfileSettingViewControllable>,
	UserProfileSettingRouting {
	private let birthdayPickerBuildable: BirthdayPickerBuildable
	private var birthdayPickerRouting: ViewableRouting?
	
	init(
		interactor: UserProfileSettingInteractable,
		viewController: UserProfileSettingViewControllable,
		birthdayPickerBuildable: BirthdayPickerBuildable
	) {
		self.birthdayPickerBuildable = birthdayPickerBuildable
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}

// MARK: - BirthdayPicker
extension ProfileSettingRouter {
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
