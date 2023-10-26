import RIBs
import GMDUtils
import OnBoarding

protocol OnBoardingRouting: Routing {
	func cleanupViews()
	func termsOfUseAttach()
	func termsOfUseDetach()
	func addressSettingAttach()
	func addressSettingDetach()
	func addressSettingDismiss()
	func userSettingAttach()
	func userSettingDetach()
	func userSettingDismiss()
	func dogSettingAttach()
	func dogSettingDetach()
}

final class OnBoardingInteractor:
	Interactor,
    OnBoardingInteractable {
	weak var router: OnBoardingRouting?
	weak var listener: OnBoardingListener?
	
	override init() { }
	
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
		router?.addressSettingAttach()
	}
}

// MARK: AddressSettingListener
extension OnBoardingInteractor {
	func addressSettingDidFinish() {
		router?.userSettingAttach()
	}
	
	func addressSettingBackButtonDidTap() {
		router?.addressSettingDetach()
	}
	
	func addressSettingDismiss() {
		router?.addressSettingDismiss()
	}
}

// MARK: UserSettingListener
extension OnBoardingInteractor {
	func userSettingDidFinish() {
		router?.dogSettingAttach()
	}
	
	func userSettingBackButtonDidTap() {
		router?.userSettingDetach()
	}
	
	func userSettingDismiss() {
		router?.userSettingDismiss()
	}
}

// MARK: DogSettingListener
extension OnBoardingInteractor {
	func dogSettingDidFinish() {
		listener?.onBoardingDidFinish()
	}
	
	func dogSettingBackButtonDidTap() {
		router?.dogSettingDetach()
	}
	
	func dogSettingDismiss() {
		router?.dogSettingDetach()
	}
}
