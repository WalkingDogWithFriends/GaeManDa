import Foundation
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
	
	@MainActor
	func didTapKakaoLoginButton() {
		Task { [weak self] in
			guard let self else { return }
			let result = await dependency.signInUseCase.kakaoLogin()
			// 카카오톡의 웹뷰가 사라지기 전에 화면이 전환되는 것을 방지하기 위해 0.3초를 기다린다.
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
				if result {
					let hasOnboardingFinished = self.dependency.signInUseCase.hasOnboardingFinished()
					self.listener?.didSignIn(hasOnboardingFinished: hasOnboardingFinished)
				}
			}
		}
	}
}
