import Foundation
import RIBs
import Entity
import OnBoarding

protocol DogProfileSettingRouting: Routing {
	func cleanupViews()
	func dogProfileFirstSettingAttach()
	func dogProfileFirstSettingDetach()
	func dogProfileFirstSettingDismiss()
	func dogProfileSecondSettingAttach(profileImage: Data?)
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
	func dogProfileSecondSettingDidTapConfirmButton(with viewModel: DogProfileSecondSettingViewModel) {
		let dog = convertToDog(from: dogSettingFirstViewModel, viewModel)

		listener?.dogProfileSettingDidFinish(with: dog)
	}
	
	func dogProfileSecondSettingDidTaBackButtonp() {
		router?.dogProfileSecondSettingDetach()
	}
	
	func dogProfileSecondSettingDismiss() {
		router?.dogProfileSecondSettingDismiss()
	}
}

// MARK: - Private Methods
private extension DogProfileSettingInteractor {
	func convertToDog(
		from firstViewModel: DogProfileFirstSettingViewModel,
		_ secondViewModel: DogProfileSecondSettingViewModel
	) -> Dog {
		return Dog(
			id: 0,
			name: firstViewModel.name,
			profileImage: secondViewModel.profileImage,
			species: DogSpecies(krRawValue: secondViewModel.species) ?? .ETC,
			gender: firstViewModel.gender,
			birthday: firstViewModel.birthday,
			weight: firstViewModel.weight,
			isNeutered: secondViewModel.isNeutered,
			characterIds: secondViewModel.characterIds
		)
	}
}
