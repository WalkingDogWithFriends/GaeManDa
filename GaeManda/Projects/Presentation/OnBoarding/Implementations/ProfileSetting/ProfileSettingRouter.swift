import RIBs
import OnBoarding

protocol ProfileSettingInteractable: Interactable {
	var router: ProfileSettingRouting? { get set }
	var listener: ProfileSettingListener? { get set }
}

protocol ProfileSettingViewControllable: ViewControllable { }

final class ProfileSettingRouter:
	ViewableRouter<ProfileSettingInteractable,
	ProfileSettingViewControllable>,
	ProfileSettingRouting {	
	override init(
		interactor: ProfileSettingInteractable,
		viewController: ProfileSettingViewControllable
	) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
