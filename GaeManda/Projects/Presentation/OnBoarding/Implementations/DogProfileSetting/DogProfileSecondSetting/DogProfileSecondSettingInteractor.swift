import Foundation
import RIBs
import RxCocoa
import RxSwift
import Entity
import GMDUtils
import OnBoarding
import UseCase

protocol DogProfileSecondSettingRouting: ViewableRouting {
	func dogProfileSecondDashboardAttach(dogSpecies: [String])
	func dogCharacterDashboardAttach(selectedCharacters: BehaviorRelay<[DogCharacter]>)
	
	func dogCharacterPickerAttach(characters: [DogCharacter], selectedId: [Int])
	func dogCharacterPickerDetach()
}

protocol DogProfileSecondSettingPresentable: Presentable {
	var listener: DogProfileSecondSettingPresentableListener? { get set }
	
	func updateProfileImage(with profileImage: UIImageWrapper)
	func setConfirmButton(isPositive: Bool)
}

protocol DogProfileSecondSettingListener: AnyObject {
	func dogProfileSecondSettingDidTapConfirmButton(with passingModel: DogProfileSecondSettingPassingModel)
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
	private let selectedCharacters = BehaviorRelay<[DogCharacter]>(value: [])
	private var selectedDogSpecies: String?
	private var isNeutered: Bool = true
	
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
		presenter.updateProfileImage(with: profileImage)

		dependency.useCase.fetchDogSpecies()
			.observe(on: MainScheduler.instance)
			.subscribe(with: self) { owner, species in
				let speciesKR = owner.convertToSpeciesKR(from: species)
				
				owner.router?.dogProfileSecondDashboardAttach(dogSpecies: speciesKR)
			}
			.disposeOnDeactivate(interactor: self)
		
		router?.dogCharacterDashboardAttach(selectedCharacters: selectedCharacters)
		
		selectedCharacters
			.bind(with: self) { owner, _ in
				owner.presenter.setConfirmButton(isPositive: owner.confirmIsPositive())
			}
			.disposeOnDeactivate(interactor: self)
	}
	
	func didTapBackButton() {
		listener?.dogProfileSecondSettingDidTaBackButtonp()
	}
	
	func dismiss() {
		listener?.dogProfileSecondSettingDismiss()
	}
	
	func didTapConfirmButton() {
		guard 
			let selectedDogSpecies = selectedDogSpecies,
			!selectedCharacters.value.isEmpty
		else { return }
		
		listener?.dogProfileSecondSettingDidTapConfirmButton(
			with: DogProfileSecondSettingPassingModel(
				species: selectedDogSpecies,
				isNeutered: self.isNeutered,
				characterIds: selectedCharacters.value.map { $0.id },
				profileImage: profileImage
			)
		)
	}
}

// MARK: - DogProfileSecondDashboardListener
extension DogProfileSecondSettingInteractor {
	func didSelectedDogSpecies(_ dogSpecies: String) {
		print("dogSpecies: \(dogSpecies)")
		self.selectedDogSpecies = dogSpecies
		presenter.setConfirmButton(isPositive: confirmIsPositive())
	}
	
	func didSelectedIsNeutered(_ isNeutered: Bool) {
		self.isNeutered = isNeutered
	}
}

extension DogProfileSecondSettingInteractor {
	func didTapAddCharacterButton() {
		dependency.useCase.fetchDogCharacters()
			.subscribe(with: self) { owner, characters in
				owner.router?.dogCharacterPickerAttach(
					characters: characters,
					selectedId: owner.selectedCharacters.value.map { $0.id }
				)
			}
			.disposeOnDeactivate(interactor: self)
	}
	
	func dogCharactersSelected(_ dogCharacters: [DogCharacter]) {
		selectedCharacters.accept(dogCharacters)
	}
	
	func dogCharacterPickerDismiss() {
		router?.dogCharacterPickerDetach()
	}
}

// MARK: - Private Methods
private extension DogProfileSecondSettingInteractor {
	func confirmIsPositive() -> Bool {
		print(selectedDogSpecies != nil)
		print(!selectedCharacters.value.isEmpty)

		return (selectedDogSpecies != nil) && (!selectedCharacters.value.isEmpty)
	}
	
	func convertToSpeciesKR(from species: [String]) -> [String] {
		return species
			.map { DogSpecies(rawValue: $0) ?? .ETC }
			.map { $0.dogSpeciesKR }
	}
}
