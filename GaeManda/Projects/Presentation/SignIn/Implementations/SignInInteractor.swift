import RIBs
import RxCocoa
import RxSwift
import SignIn
import UseCase

protocol SignInRouting: ViewableRouting { }

protocol SignInPresentable: Presentable {
	var listener: SignInPresentableListener? { get set }
}

protocol SignInInteractorDependency {
	var signInUseCase: SignInUseCase { get }
}

final class SignInInteractor:
	PresentableInteractor<SignInPresentable>,
	SignInInteractable,
	SignInPresentableListener {
	weak var router: SignInRouting?
	weak var listener: SignInListener?
	
	private let dependency: SignInInteractorDependency
	
	init(
		presenter: SignInPresentable,
		dependency: SignInInteractorDependency
	) {
		self.dependency = dependency
		super.init(presenter: presenter)
		presenter.listener = self
	}
	
	override func didBecomeActive() {
		super.didBecomeActive()
	}
	
	override func willResignActive() {
		super.willResignActive()
	}
	
	func didTapAppleLoginButton() {
		// Apple Login Bussiness Logic 구현
	}
	
	func didTapKakaoLoginButton() {
		// Kakao Login Bussiness Logic 구현
	}
}
