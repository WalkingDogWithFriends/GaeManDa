import RIBs
import RxCocoa
import RxSwift
import Entity
import GMDUtils
import OnBoarding
import UseCase

protocol OnBoardingRouting: Routing {
	func cleanupViews()
	func termsOfUseAttach()
	func termsOfUseDetach()
	func addressSettingAttach()
	func addressSettingDetach()
	func addressSettingDismiss()
	func userProfileSettingAttach()
	func userProfileSettingDetach()
	func userProfileSettingDismiss()
	func dogProfileSettingAttach()
	func dogProfileSettingDetach()
}

protocol OnBoardingInteractorDependency {
	var onBoardingUseCase: OnBoardingUseCase { get }
}

final class OnBoardingInteractor:
	Interactor,
	OnBoardingInteractable {
	weak var router: OnBoardingRouting?
	weak var listener: OnBoardingListener?
	
	private let dependency: OnBoardingInteractorDependency
	
	// MARK: - PassingModel
	// 사용시에 옵셔널일 수가 없습니다.
	private var addressPassingModel: AddressPassingModel!
	private var is마케팅정보수신동의Checked: Bool!
	
	// MARK: - Entity
	// 사용시에 옵셔널일 수가 없습니다.
	private var user: User!
	
	init(dependency: OnBoardingInteractorDependency) {
		self.dependency = dependency
		super.init()
	}
	
	override func didBecomeActive() {
		super.didBecomeActive()
	}
	
	override func willResignActive() {
		super.willResignActive()
		
		router?.cleanupViews()
	}
}

// MARK: TermsOfUseListener
extension OnBoardingInteractor {
	func termsOfUseDidFinish(with is마케팅정보수신동의Checked: Bool) {
		self.is마케팅정보수신동의Checked = is마케팅정보수신동의Checked
		router?.addressSettingAttach()
	}
}

// MARK: AddressSettingListener
extension OnBoardingInteractor {
	func addressSettingDidFinish(with address: AddressPassingModel) {
		self.addressPassingModel = address
		router?.userProfileSettingAttach()
	}
	
	func addressSettingDidFinish() {
	}
	
	func addressSettingBackButtonDidTap() {
		router?.addressSettingDetach()
	}
	
	func addressSettingDismiss() {
		router?.addressSettingDismiss()
	}
}

// MARK: UserProfileSettingListener
extension OnBoardingInteractor {
	func userProfileSettingDidFinish(with passingModel: UserProfileSettingPassingModel) {
		self.user = convertToUser(addressPassingModel, passingModel)
		router?.dogProfileSettingAttach()
	}
	
	func userProfileSettingBackButtonDidTap() {
		router?.userProfileSettingDetach()
	}
	
	func userProfileSettingDismiss() {
		router?.userProfileSettingDismiss()
	}
}

// MARK: DogProfileSettingListener
extension OnBoardingInteractor {
	func dogProfileSettingDidFinish(with dog: Dog?) {
		guard let dog = dog else {
			// 에러로 인해 끝난 경우, 강아지 설정 이전 페이지로 이동
			router?.dogProfileSettingDetach()
			return
		}
		
		listener?.onBoardingDidFinish()
		
//		dependency.onBoardingUseCase.didFinish(
//			user: user,
//			dog: dog,
//			is마케팅정보수신동의Checked: is마케팅정보수신동의Checked
//		)
//		.observe(on: MainScheduler.instance)
//		.subscribe(
//			with: self,
//			onSuccess: { owner, _ in
//				owner.listener?.onBoardingDidFinish()
//			},
//			onFailure: { _, _ in
//				// 에러 정책??
//			}
//		)
//		.disposeOnDeactivate(interactor: self)
	}
	
	func dogProfileSettingBackButtonDidTap() {
		router?.dogProfileSettingDetach()
	}
	
	func dogProfileSettingDismiss() {
		router?.dogProfileSettingDetach()
	}
}

// MARK: - Create Entity Methods
private extension OnBoardingInteractor {
	func convertToUser(_ address: AddressPassingModel, _ user: UserProfileSettingPassingModel) -> User {
		return User(
			id: 0,
			name: user.nickname,
			gender: user.gender,
			address: Location(latitude: address.latitude, longitude: address.longitude),
			birthday: user.birthday,
			profileImage: user.profileImage.toUTF8
		)
	}
}
