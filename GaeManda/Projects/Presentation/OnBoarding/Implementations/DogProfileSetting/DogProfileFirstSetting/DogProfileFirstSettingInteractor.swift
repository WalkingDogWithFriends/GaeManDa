import RIBs
import RxRelay
import RxSwift
import Entity
import GMDUtils
import OnBoarding

protocol DogProfileFirstSettingRouting: ViewableRouting {
	func dogProfileFirstDashboardAttach(
		nameTextFieldIsWarning: BehaviorRelay<Void>,
		birthdayTextFieldIsWarning: BehaviorRelay<Void>,
		weightTextFieldIsWarning: BehaviorRelay<Void>
	)
}

protocol DogProfileFirstSettingPresentable: Presentable {
	var listener: DogProfileFirstSettingPresentableListener? { get set }
	
	func setConfirmButton(isPositive: Bool)
}

protocol DogProfileFirstSettingListener: AnyObject {
	func dogProfileFirstSettingDidTapConfirmButton(with passingModel: DogProfileFirstSettingPassingModel)
	func dogProfileFirstSettingDidTapBackButton()
	func dogProfileFirstSettingDismiss()
}

final class DogProfileFirstSettingInteractor:
	PresentableInteractor<DogProfileFirstSettingPresentable>,
	DogProfileFirstSettingInteractable {
	weak var router: DogProfileFirstSettingRouting?
	weak var listener: DogProfileFirstSettingListener?
	
	private let nameTextFieldIsWarning = BehaviorRelay<Void>(value: ())
	private let birthdayTextFieldIsWarning = BehaviorRelay<Void>(value: ())
	private let weightTextFieldIsWarning = BehaviorRelay<Void>(value: ())
	
	private var selectedGender: Gender = .male
	private var selectedBirthday: String?
	private var enteredDogName: String?
	private var enteredDogWeight: Int?
	
	override init(presenter: DogProfileFirstSettingPresentable) {
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
extension DogProfileFirstSettingInteractor: DogProfileFirstSettingPresentableListener {
	func viewDidLoad() {
		router?.dogProfileFirstDashboardAttach(
			nameTextFieldIsWarning: nameTextFieldIsWarning,
			birthdayTextFieldIsWarning: birthdayTextFieldIsWarning,
			weightTextFieldIsWarning: weightTextFieldIsWarning
		)
	}
	
	func didTapConfirmButton(with profileImage: UIImageWrapper) {
		if selectedBirthday == nil {
			birthdayTextFieldIsWarning.accept(())
		}
		if enteredDogName == nil {
			nameTextFieldIsWarning.accept(())
		}
		if enteredDogWeight == nil {
			weightTextFieldIsWarning.accept(())
		}
		
		guard
			let selectedBirthday = selectedBirthday,
			let enteredDogName = enteredDogName,
			let enteredDogWeight = enteredDogWeight
		else { return }
		
		listener?.dogProfileFirstSettingDidTapConfirmButton(
			with: DogProfileFirstSettingPassingModel(
				name: enteredDogName,
				birthday: selectedBirthday,
				gender: selectedGender,
				weight: enteredDogWeight,
				profileImage: profileImage
			)
		)
	}
	
	func didTapBackButton() {
		listener?.dogProfileFirstSettingDidTapBackButton()
	}
	
	func dismiss() {
		listener?.dogProfileFirstSettingDismiss()
	}
}

// MARK: - DogProfileFirstDashboardListener
extension DogProfileFirstSettingInteractor {
	func didSelectedGender(_ gender: Gender) {
		self.selectedGender = gender
	}
	
	func didSelectedBirthday(_ date: String) {
		defer { presenter.setConfirmButton(isPositive: confirmIsPositive()) }
		
		if date.isEmpty {
			self.selectedBirthday = nil
		} else {
			self.selectedBirthday = date
		}
	}
	
	func didEnteredDogName(_ name: String) {
		defer { presenter.setConfirmButton(isPositive: confirmIsPositive()) }

		if name.isEmpty {
			self.enteredDogName = nil
		} else {
			self.enteredDogName = name
		}
	}
	
	func didEnteredDogWeight(_ weight: Int) {
		defer { presenter.setConfirmButton(isPositive: confirmIsPositive()) }

		if weight == -1 {
			self.enteredDogWeight = nil
		} else {
			self.enteredDogWeight = weight
		}
	}
}

// MARK: - Private Method
private extension DogProfileFirstSettingInteractor {
	func confirmIsPositive() -> Bool {
		return (selectedBirthday != nil) && (enteredDogName != nil) && (enteredDogWeight != nil)
	}
}
