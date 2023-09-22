import RIBs
import OnBoarding

protocol DogSettingRouting: Routing {
	func cleanupViews()
	func firstDogSettingAttach()
	func firstDogSettingDetach()
	func firstDogSettingDidFinish()
	func secondDogSettingAttach()
	func secondDogSettingDetach()
	func secondDogSettingDidFinish()
	func thirdDogSettingAttach()
	func thirdDogSettingDetach()
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
	func firstDogSettingDidFinish() {
		router?.firstDogSettingDidFinish()
	}
	
	func firstDogSettingBackButtonDidTap() {
		listener?.dogSettingBackButtonDidTap()
	}
	
	func firstDogSettingDismiss() {
		listener?.dogSettingDismiss()
	}
}

// MARK: SecondDogSetting
extension DogSettingInteractor {
	func secondDogSettingDidFinish() {
		router?.secondDogSettingDidFinish()
	}
	
	func secondDogSettingBackButtonDidTap() {
		router?.secondDogSettingDetach()
	}
}

// MARK: ThirdDogSetting
extension DogSettingInteractor {
	func thirdDogSettingDidFinish() {
		listener?.dogSettingDidFinish()
	}
	
	func thirdDogSettingBackButtonDidTap() {
		router?.thirdDogSettingDetach()
	}
}
