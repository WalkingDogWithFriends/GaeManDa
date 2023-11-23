import RIBs
import Entity

protocol SecondDogSettingRouting: ViewableRouting {
	func dogCharacterPickerAttach(with selectedId: [Int])
	func dogCharacterPickerDetach()
}

protocol SecondDogSettingPresentable: Presentable {
	var listener: SecondDogSettingPresentableListener? { get set }
	
	func updateDogCharacter(with selectedCharaters: [DogCharacter])
}

protocol SecondDogSettingListener: AnyObject {
	func secondDogSettingDidTapConfirmButton()
	func secondDogSettingDidTaBackButtonp()
	func secondDogSettingDismiss()
}

final class SecondDogSettingInteractor:
	PresentableInteractor<SecondDogSettingPresentable>,
	SecondDogSettingInteractable,
	SecondDogSettingPresentableListener {
	weak var router: SecondDogSettingRouting?
	weak var listener: SecondDogSettingListener?
	
	override init(presenter: SecondDogSettingPresentable) {
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
extension SecondDogSettingInteractor {
	func didTapConfirmButton() {
		listener?.secondDogSettingDidTapConfirmButton()
	}
	
	func didTapBackButton() {
		listener?.secondDogSettingDidTaBackButtonp()
	}
	
	func dismiss() {
		listener?.secondDogSettingDismiss()
	}
	
	func didTapAddDogCharacterButton(with selectedCharaters: [DogCharacter]) {
		router?.dogCharacterPickerAttach(with: selectedCharaters.map { $0.id })
	}
}

// MARK: - DogCharacterPickerListener
extension SecondDogSettingInteractor {
	func dogCharactersSelected(_ dogCharacters: [DogCharacter]) {
		presenter.updateDogCharacter(with: dogCharacters)
	}
	
	func dogCharacterPickerDismiss() {
		router?.dogCharacterPickerDetach()
	}
}
