import RIBs
import OnBoarding

protocol DogProfileSettingRouting: Routing {
	func cleanupViews()
	func dogProfileFirstSettingAttach()
	func dogProfileFirstSettingDetach()
	func dogProfileFirstSettingDismiss()
	func dogProfileSecondSettingAttach()
	func dogProfileSecondSettingDetach()
	func dogProfileSecondSettingDismiss()
}

final class DogProfileSettingInteractor: Interactor, DogProfileSettingInteractable {
	weak var router: DogProfileSettingRouting?
	weak var listener: DogProfileSettingListener?
	
	private var dogSettingFirstViewModel: DogProfileFirstSettingViewModel = .default
	
	override init() {}
	
	override func didBecomeActive() {
		super.didBecomeActive()
	}
	
	override func willResignActive() {
		super.willResignActive()
		
		router?.cleanupViews()
	}
}

// MARK: DogProfileFirstSetting
extension DogProfileSettingInteractor {
	func dogProfileFirstSettingDidTapConfirmButton(with viewModel: DogProfileFirstSettingViewModel) {
		self.dogSettingFirstViewModel = viewModel
		router?.dogProfileSecondSettingAttach(profileImage: viewModel.profileImage)
	}
	
	func dogProfileFirstSettingDidTapBackButton() {
		listener?.dogProfileSettingBackButtonDidTap()
	}
	
	func dogProfileFirstSettingDismiss() {
		listener?.dogProfileSettingDismiss()
	}
}

// MARK: DogProfileSecondSetting
extension DogProfileSettingInteractor {
	func dogProfileSecondSettingDidTapConfirmButton() {
		listener?.dogProfileSettingDidFinish()
	}
	
	func dogProfileSecondSettingDidTaBackButtonp() {
		router?.dogProfileSecondSettingDetach()
	}
	
	func dogProfileSecondSettingDismiss() {
		router?.dogProfileSecondSettingDismiss()
	}
}
