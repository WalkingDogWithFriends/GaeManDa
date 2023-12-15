import RIBs
import RxSwift
import RxRelay
import CorePresentation
import Entity
import OnBoarding
import GMDUtils

protocol UserProfileSettingRouting: ViewableRouting {
	func attachUserProfileDashboard(
		usernameTextFieldModeRelay: BehaviorRelay<NicknameTextFieldMode>,
		birthdayTextFieldIsWarningRelay: BehaviorRelay<Bool>
	)
}

protocol UserProfileSettingPresentable: Presentable {
	var listener: UserProfileSettingPresentableListener? { get set }
	
	func setConfirmButton(isEnabled: Bool)
}

final class UserProfileSettingInteractor:
	PresentableInteractor<UserProfileSettingPresentable>,
	UserProfileSettingInteractable,
	UserProfileSettingPresentableListener {
	weak var router: UserProfileSettingRouting?
	weak var listener: UserProfileSettingListener?
	
	private let userNameTextFieldMode = BehaviorRelay<NicknameTextFieldMode>(value: .default)
	private let birthdayTextFieldIsWarning = BehaviorRelay<Bool>(value: false)
	
	private var selectedGender: Gender = .male
	private var enteredUserName: String?
	private var selectedBirthday: String?
	
	override init(presenter: UserProfileSettingPresentable) {
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

// MARK: - PresentableListener
extension UserProfileSettingInteractor {
	func viewDidLoad() {
		router?.attachUserProfileDashboard(
			usernameTextFieldModeRelay: userNameTextFieldMode,
			birthdayTextFieldIsWarningRelay: birthdayTextFieldIsWarning
		)
		
//		Observable.merge(
//			birthdayTextFieldIsWarning.map { !$0 },
//			userNameTextFieldMode.map { $0 == .valid }
//		)
//		.bind(with: self) { owner, isPositive in
//			owner.presenter.setConfirmButton(isEnabled: isPositive)
//		}
//		.disposeOnDeactivate(interactor: self)
	}
	
	func confirmButtonDidTap(with profileImage: UIImageWrapper) {
		if selectedBirthday == nil {
			birthdayTextFieldIsWarning.accept(true)
		}
		if enteredUserName == nil {
			userNameTextFieldMode.accept(.notEntered)
		}
		
		guard userNameTextFieldMode.value == .valid else { return }
		
		guard let selectedBirthday = selectedBirthday, let enteredUserName = enteredUserName else { return }
		
		listener?.userProfileSettingDidFinish(
			with: UserProfileSettingPassingModel(
				nickname: enteredUserName,
				birthday: selectedBirthday,
				gender: selectedGender,
				profileImage: profileImage
			)
		)
	}
	
	func backButtonDidTap() {
		listener?.userProfileSettingBackButtonDidTap()
	}
	
	func dismiss() {
		listener?.userProfileSettingDismiss()
	}
}

// MARK: - UserProfileDashboardListener
extension UserProfileSettingInteractor {
	func didSelectedGender(_ gender: Gender) {
		self.selectedGender = gender
	}
	
	func didEnteredUserName(_ name: String) {
		// TODO: - useCase 이름 중복 검사
		// 유저 이름이 있는 경우,
		if name.isEmpty {
			enteredUserName = name
			self.userNameTextFieldMode.accept(.default)
		} else if name.count > 4 {
			enteredUserName = name
			self.userNameTextFieldMode.accept(.duplicate)
		} else {
			enteredUserName = name
			self.userNameTextFieldMode.accept(.valid)
		}
	}
	
	func didSelectedBirthday(_ date: String) {
		self.selectedBirthday = date
	}
}
