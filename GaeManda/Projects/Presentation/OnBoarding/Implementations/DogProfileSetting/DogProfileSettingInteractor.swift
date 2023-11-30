import Foundation
import RIBs
import Entity
import GMDUtils
import OnBoarding

protocol DogProfileSettingRouting: Routing {
	func cleanupViews()
	func dogProfileFirstSettingAttach()
	func dogProfileFirstSettingDetach()
	func dogProfileFirstSettingDismiss()
	func dogProfileSecondSettingAttach(profileImage: UIImageWrapper)
	func dogProfileSecondSettingDetach()
	func dogProfileSecondSettingDismiss()
}

final class DogProfileSettingInteractor: Interactor, DogProfileSettingInteractable {
	weak var router: DogProfileSettingRouting?
	weak var listener: DogProfileSettingListener?

	private var dogSettingFirstViewModel: DogProfileFirstSettingViewModel?
	
	override init() { }
	
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
		guard let dogSettingFirstViewModel = dogSettingFirstViewModel else {
			listener?.dogProfileSettingDidFinish(with: nil)
			return
		}
		
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
			species: DogSpecies(krRawValue: secondViewModel.species) ?? .ETC,
			gender: firstViewModel.gender,
			birthday: firstViewModel.birthday,
			weight: firstViewModel.weight,
			isNeutered: secondViewModel.isNeutered,
			characterIds: secondViewModel.characterIds,
			profileImage: secondViewModel.profileImage.toData
		)
	}
}
