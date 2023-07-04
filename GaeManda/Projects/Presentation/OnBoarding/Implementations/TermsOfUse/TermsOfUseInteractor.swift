import RIBs
import OnBoarding

protocol TermsOfUseRouting: ViewableRouting { }

protocol TermsOfUsePresentable: Presentable {
	var listener: TermsOfUsePresentableListener? { get set }
}

final class TermsOfUseInteractor:
	PresentableInteractor<TermsOfUsePresentable>,
	TermsOfUseInteractable,
	TermsOfUsePresentableListener {
	weak var router: TermsOfUseRouting?
	weak var listener: TermsOfUseListener?
	
	override init(presenter: TermsOfUsePresentable) {
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
extension TermsOfUseInteractor {
	func confirmButtonDidTap() {
		listener?.termsOfUseDidFinish()
	}
}
