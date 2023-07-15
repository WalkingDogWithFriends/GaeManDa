import SignIn
import RIBs

protocol SignInRouting: ViewableRouting { }

protocol SignInPresentable: Presentable {
	var listener: SignInPresentableListener? { get set }
}

final class SignInInteractor:
	PresentableInteractor<SignInPresentable>,
	SignInInteractable,
	SignInPresentableListener {
	weak var router: SignInRouting?
	weak var listener: SignInListener?
	
	override init(presenter: SignInPresentable) {
		super.init(presenter: presenter)
		presenter.listener = self
	}
	
	override func didBecomeActive() {
		super.didBecomeActive()
	}
	
	override func willResignActive() {
		super.willResignActive()
	}
	
	func appleLoginButtonDidTapped() {
		// Apple Login Bussiness Logic 구현
	}
	
	func kakaoLoginButtonDidTapped() {
		// Kakao Login Bussiness Logic 구현
	}
}
