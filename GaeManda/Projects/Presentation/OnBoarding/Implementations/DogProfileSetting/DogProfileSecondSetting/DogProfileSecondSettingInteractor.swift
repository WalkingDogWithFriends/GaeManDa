import RIBs
import Entity

protocol DogProfileSecondSettingRouting: ViewableRouting {
	func dogCharacterPickerAttach(with selectedId: [Int])
	func dogCharacterPickerDetach()
}

protocol DogProfileSecondSettingPresentable: Presentable {
	var listener: DogProfileSecondSettingPresentableListener? { get set }
	
	func updateDogCharacter(with selectedCharaters: [DogCharacter])
}

protocol DogProfileSecondSettingListener: AnyObject {
	func dogProfileSecondSettingDidTapConfirmButton()
	func dogProfileSecondSettingDidTaBackButtonp()
	func dogProfileSecondSettingDismiss()
}

final class DogProfileSecondSettingInteractor:
	PresentableInteractor<DogProfileSecondSettingPresentable>,
	DogProfileSecondSettingInteractable,
	DogProfileSecondSettingPresentableListener {
	weak var router: DogProfileSecondSettingRouting?
	weak var listener: DogProfileSecondSettingListener?
	
	override init(presenter: DogProfileSecondSettingPresentable) {
		super.init(presenter: presenter)
		presenter.listener = self
	}
	
	override func didBecomeActive() {
		super.didBecomeActive()
	}
	
	override func willResignActive() {
		super.willResignActive()
	}
}

// MARK: PresentableListener
extension DogProfileSecondSettingInteractor {
	func didTapConfirmButton() {
		listener?.dogProfileSecondSettingDidTapConfirmButton()
	}
	
	func didTapBackButton() {
		listener?.dogProfileSecondSettingDidTaBackButtonp()
	}
	
	func dismiss() {
		listener?.dogProfileSecondSettingDismiss()
	}
	
	func didTapAddDogCharacterButton(with selectedCharaters: [DogCharacter]) {
		router?.dogCharacterPickerAttach(with: selectedCharaters.map { $0.id })
	}
}

extension DogProfileSecondSettingInteractor {
	func dogCharactersSelected(_ dogCharacters: [DogCharacter]) {
		presenter.updateDogCharacter(with: dogCharacters)
	}
	
	func dogCharacterPickerDismiss() {
		router?.dogCharacterPickerDetach()
	}
}
