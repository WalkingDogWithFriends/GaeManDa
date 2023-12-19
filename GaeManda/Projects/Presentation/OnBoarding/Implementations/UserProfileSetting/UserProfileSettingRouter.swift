import Foundation
import RIBs
import RxRelay
import CorePresentation
import DesignKit
import OnBoarding

protocol UserProfileSettingInteractable: Interactable, UserProfileDashboardListener {
	var router: UserProfileSettingRouting? { get set }
	var listener: UserProfileSettingListener? { get set }
}

protocol UserProfileSettingViewControllable: ViewControllable {
	func addUserProfileDashboard(_ viewControllable: ViewControllable)
}

final class UserProfileSettingRouter:
	ViewableRouter<UserProfileSettingInteractable, UserProfileSettingViewControllable>,
	UserProfileSettingRouting {
	private let userProfileDashboardBuildable: UserProfileDashboardBuildable
	private var userProfileDashboardRouting: ViewableRouting?
	
	init(
		interactor: UserProfileSettingInteractable,
		viewController: UserProfileSettingViewControllable,
		userProfileDashboardBuildable: UserProfileDashboardBuildable
	) {
		self.userProfileDashboardBuildable = userProfileDashboardBuildable
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}

// MARK: - UserProfileDashboard
extension UserProfileSettingRouter {
	func attachUserProfileDashboard(
		usernameTextFieldModeRelay: BehaviorRelay<NicknameTextFieldMode>,
		birthdayTextFieldIsWarningRelay: BehaviorRelay<Bool>
	) {
		guard userProfileDashboardRouting == nil else { return }
		let router = userProfileDashboardBuildable.build(
			withListener: interactor,
			nicknameTextFieldMode: usernameTextFieldModeRelay,
			birthdayTextFieldIsWarning: birthdayTextFieldIsWarningRelay,
			userProfilePassingModel: nil
		)
		
		self.userProfileDashboardRouting = router
		attachChild(router)
		viewController.addUserProfileDashboard(router.viewControllable)
	}
}
