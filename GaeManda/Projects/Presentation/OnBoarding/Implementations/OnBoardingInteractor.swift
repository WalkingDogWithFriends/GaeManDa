import RIBs
import OnBoarding
import Utils

protocol OnBoardingRouting: Routing {
	func cleanupViews()
	func termsOfUseAttach()
	func termsOfUseDetach()
	func termsOfUseDidFinish()
	func addressSettingAttach()
	func addressSettingDetach()
	func addressSettingDidFinish()
	func userSettingAttach()
	func userSettingDetach()
	func userSettingDidFinish()
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

// MARK: TermsOfUseListener
extension OnBoardingInteractor {
	func termsOfUseDidFinish() {
		router?.termsOfUseDidFinish()
	}
}

// MARK: AddressSettingListener
extension OnBoardingInteractor {
	func addressSettingDidFinish() {
		router?.addressSettingDidFinish()
	}
	
	func addressSettingBackButtonDidTap() {
		router?.addressSettingDetach()
	}
}

// MARK: UserSettingListener
extension OnBoardingInteractor {
	func userSettingDidFinish() {
		router?.userSettingDidFinish()
	}
	
	func userSettingBackButtonDidTap() {
		router?.userSettingDetach()
	}
}
