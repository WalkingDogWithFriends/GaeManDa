import RIBs
import GMDUtils
import OnBoarding

protocol OnBoardingRouting: Routing {
	func cleanupViews()
	func termsOfUseAttach()
	func termsOfUseDetach()
	func termsOfUseDidFinish()
	func addressSettingAttach()
	func addressSettingDetach()
	func addressSettingDidFinish()
	func detailAddressSettingAttach()
	func detailAddressSettingDetach()
	func detailAddressSettingDismiss()
	func userSettingAttach()
	func userSettingDetach()
	func userSettingDidFinish()
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
	
	func addressSettingDismiss() {
		router?.addressSettingDetach()
	}
}

// MARK: DetailAddressSettingListener
extension OnBoardingInteractor {
	func addressSettingDidTapSearchTextField() {
		router?.detailAddressSettingAttach()
	}
	
	func detailAddressSettingDidDismiss() {
		router?.detailAddressSettingDismiss()
	}
	
	func detailAddressSettingCloseButtonDidTap() {
		router?.detailAddressSettingDetach()
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
	
	func userSettingDismiss() {
		router?.userSettingDetach()
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
