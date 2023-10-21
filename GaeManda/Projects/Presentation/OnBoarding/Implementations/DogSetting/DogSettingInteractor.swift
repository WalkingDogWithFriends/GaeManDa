import RIBs
import OnBoarding

protocol DogSettingRouting: Routing {
	func cleanupViews()
	func firstDogSettingAttach()
	func firstDogSettingDetach()
	func firstDogSettingDismiss()
	func firstDogSettingDidFinish()
	func secondDogSettingAttach()
	func secondDogSettingDetach()
	func secondDogSettingDismiss()
}

final class DogSettingInteractor: Interactor, DogSettingInteractable {
	weak var router: DogSettingRouting?
	weak var listener: DogSettingListener?
	
	override init() {}
	
	override func didBecomeActive() {
		super.didBecomeActive()
	}
	
	override func willResignActive() {
		super.willResignActive()
		
		router?.cleanupViews()
	}
}

// MARK: FirstDogSetting
extension DogSettingInteractor {
	func firstDogSettingDidTapConfirmButton() {
		router?.firstDogSettingDidFinish()
	}
	
	func firstDogSettingDidTapBackButton() {
		listener?.dogSettingBackButtonDidTap()
	}
	
	func firstDogSettingDismiss() {
		router?.firstDogSettingDismiss()
		listener?.dogSettingDismiss()
	}
}

// MARK: SecondDogSetting
extension DogSettingInteractor {
	func secondDogSettingDidTapConfirmButton() {
		listener?.dogSettingDidFinish()
	}
	
	func secondDogSettingDidTaBackButtonp() {
		router?.secondDogSettingDetach()
	}
	
	func secondDogSettingDismiss() {
		router?.secondDogSettingDismiss()
	}
}
