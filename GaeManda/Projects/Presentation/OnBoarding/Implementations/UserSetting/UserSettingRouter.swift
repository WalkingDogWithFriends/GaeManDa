import RIBs
import OnBoarding

protocol UserSettingInteractable: Interactable {
	var router: UserSettingRouting? { get set }
	var listener: UserSettingListener? { get set }
}

protocol UserSettingViewControllable: ViewControllable { }

final class ProfileSettingRouter:
	ViewableRouter<UserSettingInteractable, UserSettingViewControllable>,
	UserSettingRouting {	
	override init(
		interactor: UserSettingInteractable,
		viewController: UserSettingViewControllable
	) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
