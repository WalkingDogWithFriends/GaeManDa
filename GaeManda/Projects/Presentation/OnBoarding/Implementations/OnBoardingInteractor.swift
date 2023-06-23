import RIBs
import OnBoarding
import Utils

protocol OnBoardingRouting: Routing {
	func cleanupViews()
	func profileSettingAttach()
	func profileSettingDetach()
}

final class OnBoardingInteractor:
	Interactor,
	OnBoardingInteractable {
	weak var router: OnBoardingRouting?
	weak var listener: OnBoardingListener?
	
	override init() {	}
	
	override func didBecomeActive() {
		super.didBecomeActive()
	}
	
	override func willResignActive() {
		super.willResignActive()
		
		router?.cleanupViews()
	}
}
