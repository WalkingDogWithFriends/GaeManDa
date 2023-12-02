import RIBs
import Entity
import GMDUtils
import OnBoarding

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

final class OnBoardingInteractor:
	Interactor,
	OnBoardingInteractable {
	weak var router: OnBoardingRouting?
	weak var listener: OnBoardingListener?
	
	// MARK: - PassingModel
	// 사용시에 옵셔널일 수가 없습니다.
	private var addressPassingModel: AddressPassingModel!

	// MARK: - Entity
	// 사용시에 옵셔널일 수가 없습니다.
	private var user: User!
	private var dog: Dog!
	
	override init() { }
	
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
	func termsOfUseDidFinish() {
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
		convertToUser(addressPassingModel, passingModel)
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
		self.dog = dog
		// 정상 종료된 경우, 온보딩으로 데이터 전달.
		listener?.onBoardingDidFinish()
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
		let addressLocation = Location(latitude: address.latitude, longitude: address.longitude)
		
		return User(
			id: 0,
			name: user.nickname,
			gender: user.gender,
			address: addressLocation,
			birthday: user.birthday,
			profileImage: user.profileImage.toUTF8
		)
	}
}
