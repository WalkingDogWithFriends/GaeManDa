import RIBs
import Entity
import GMDUtils
import OnBoarding

protocol OnBoardingRouting: Routing {
	func cleanupViews()
	func termsOfUseAttach()
	func termsOfUseDetach()
	func addressSettingAttach()
	func addressSettingDetach()
	func addressSettingDismiss()
	func userProfileSettingAttach()
	func userProfileSettingDetach()
	func userProfileSettingDismiss()
	func dogProfileSettingAttach()
	func dogProfileSettingDetach()
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
		router?.userProfileSettingAttach()
	}
	
	func addressSettingBackButtonDidTap() {
		router?.addressSettingDetach()
	}
	
	func addressSettingDismiss() {
		router?.addressSettingDismiss()
	}
}

// MARK: UserProfileSettingListener
extension OnBoardingInteractor {
	func userProfileSettingDidFinish() {
		router?.dogProfileSettingAttach()
	}
	
	func userProfileSettingBackButtonDidTap() {
		router?.userProfileSettingDetach()
	}
	
	func userProfileSettingDismiss() {
		router?.userProfileSettingDismiss()
	}
}

// MARK: DogProfileSettingListener
extension OnBoardingInteractor {
	func dogProfileSettingDidFinish(with dog: Dog) {
		listener?.onBoardingDidFinish()
	}
	
	func dogProfileSettingBackButtonDidTap() {
		router?.dogProfileSettingDetach()
	}
	
	func dogProfileSettingDismiss() {
		router?.dogProfileSettingDetach()
	}
}
