import Foundation
import RIBs
import RxCocoa
import RxSwift
import Entity
import GMDUtils
import UseCase

protocol DogProfileSecondSettingRouting: ViewableRouting {
	func dogCharacterPickerAttach(characters: [DogCharacter], selectedId: [Int])
	func dogCharacterPickerDetach()
}

protocol DogProfileSecondSettingPresentable: Presentable {
	var listener: DogProfileSecondSettingPresentableListener? { get set }
	
	func updateDogCharacter(with selectedCharaters: [DogCharacter])
	func updateDogSpecies(with dogSpecies: [String])
	func updateProfileImage(with profileImage: UIImageWrapper)
}

protocol DogProfileSecondSettingListener: AnyObject {
	func dogProfileSecondSettingDidTapConfirmButton(with viewModel: DogProfileSecondSettingViewModel)
	func dogProfileSecondSettingDidTaBackButtonp()
	func dogProfileSecondSettingDismiss()
}

// swiftlint:disable:next type_name
protocol DogProfileSecondSettingInteractorDependency {
	var useCase: OnBoardingUseCase { get }
}

final class DogProfileSecondSettingInteractor:
	PresentableInteractor<DogProfileSecondSettingPresentable>,
	DogProfileSecondSettingInteractable,
	DogProfileSecondSettingPresentableListener {
	weak var router: DogProfileSecondSettingRouting?
	weak var listener: DogProfileSecondSettingListener?
	
	let dependency: DogProfileSecondSettingInteractorDependency
	private let profileImage: UIImageWrapper
	
	init(
		presenter: DogProfileSecondSettingPresentable,
		dependency: DogProfileSecondSettingInteractorDependency,
		profileImage: UIImageWrapper
	) {
		self.dependency = dependency
		self.profileImage = profileImage
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
	func viewDidLoad() {
		dependency.useCase.fetchDogSpecies()
			.observe(on: MainScheduler.instance)
			.subscribe(with: self) { owner, species in
				owner.presenter.updateDogSpecies(with: owner.convertToSpeciesKR(from: species))
			}
			.disposeOnDeactivate(interactor: self)
		
		presenter.updateProfileImage(with: profileImage)
	}
	
	func didTapBackButton() {
		listener?.dogProfileSecondSettingDidTaBackButtonp()
	}
	
	func dismiss() {
		listener?.dogProfileSecondSettingDismiss()
	}
	
	func didTapAddDogCharacterButton(with selectedCharaters: [DogCharacter]) {
		dependency.useCase.fetchDogCharacters()
			.subscribe(with: self) { owner, characters in
				owner.router?.dogCharacterPickerAttach(
					characters: characters,
					selectedId: selectedCharaters.map { $0.id }
				)
			}
			.disposeOnDeactivate(interactor: self)
	}
	
	func didTapConfirmButton(with viewModel: DogProfileSecondSettingViewModel) {
		listener?.dogProfileSecondSettingDidTapConfirmButton(with: viewModel)
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

// MARK: - Private Methods
private extension DogProfileSecondSettingInteractor {
	func convertToSpeciesKR(from species: [String]) -> [String] {
		return species
			.map { DogSpecies(rawValue: $0) ?? .ETC }
			.map { $0.dogSpeciesKR }
	}
}
