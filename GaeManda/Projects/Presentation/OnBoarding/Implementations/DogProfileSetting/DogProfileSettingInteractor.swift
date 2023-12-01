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

	private var dogProfileFirstSettingModel: DogProfileFirstSettingPassingModel?
	
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
	func dogProfileFirstSettingDidTapConfirmButton(with passingModel: DogProfileFirstSettingPassingModel) {
		self.dogProfileFirstSettingModel = passingModel
		router?.dogProfileSecondSettingAttach(profileImage: passingModel.profileImage)
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
	func dogProfileSecondSettingDidTapConfirmButton(with passingModel: DogProfileSecondSettingPassingModel) {
		guard let dogProfileFirstSettingModel = dogProfileFirstSettingModel else {
			listener?.dogProfileSettingDidFinish(with: nil)
			return
		}
		
		let dog = convertToDog(from: dogProfileFirstSettingModel, passingModel)

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
		from firstModel: DogProfileFirstSettingPassingModel,
		_ secondModel: DogProfileSecondSettingPassingModel
	) -> Dog {
		return Dog(
			id: 0,
			name: firstModel.name,
			species: DogSpecies(krRawValue: secondModel.species) ?? .ETC,
			gender: firstModel.gender,
			birthday: firstModel.birthday,
			weight: firstModel.weight,
			isNeutered: secondModel.isNeutered,
			characterIds: secondModel.characterIds,
			profileImage: secondModel.profileImage.toData
		)
	}
}
