import RIBs
import OnBoarding

protocol TermsOfUseRouting: ViewableRouting { }

protocol TermsOfUsePresentable: Presentable {
	var listener: TermsOfUsePresentableListener? { get set }
	
	func set약관전체동의Button(isChecked: Bool)
	func set이용약관동의Button(isChecked: Bool)
	func set개인정보수집및이용동의Button(isChecked: Bool)
	func set위치정보수집및이용동의Button(isChecked: Bool)
	func set마케팅정보수신동의Button(isChecked: Bool)
	func setConfirmButton(isEnabled: Bool)
}

final class TermsOfUseInteractor:
	PresentableInteractor<TermsOfUsePresentable>,
	TermsOfUseInteractable,
	TermsOfUsePresentableListener {
	weak var router: TermsOfUseRouting?
	weak var listener: TermsOfUseListener?
	private var termsOfUseViewModel = TermsOfUseViewModel()
	
	override init(presenter: TermsOfUsePresentable) {
		super.init(presenter: presenter)
		presenter.listener = self
	}
	
	override func didBecomeActive() {
		super.didBecomeActive()
		self.bind()
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
	
	func a약관전체동의ButtonDidTap() {
		termsOfUseViewModel.a약관전체동의ButtonDidTap()
	}
	
	func a이용약관동의ButtonDidTap() {
		termsOfUseViewModel.a이용약관동의ButtonDidTap()
	}
	
	func a개인정보수집및이용동의ButtonDidTap() {
		termsOfUseViewModel.a개인정보수집및이용동의ButtonDidTap()
	}
	
	func a위치정보수집및이용동의DidTap() {
		termsOfUseViewModel.a위치정보수집및이용동의ButtonDidTap()
	}
	
	func a마케팅정보수신동의DidTap() {
		termsOfUseViewModel.a마케팅정보수신동의ButtonDidTap()
	}
}

private extension TermsOfUseInteractor {
	func bind() {
		termsOfUseViewModel.is약관전체동의ChekcedRelay
			.bind(with: self) { owner, isChekd in
				owner.presenter.set약관전체동의Button(isChecked: isChekd)
			}
			.disposeOnDeactivate(interactor: self)
		
		termsOfUseViewModel.is이용약관동의CheckedRelay
			.bind(with: self) { owner, isChecked in
				owner.presenter.set이용약관동의Button(isChecked: isChecked)
			}
			.disposeOnDeactivate(interactor: self)
		
		termsOfUseViewModel.is개인정보수집및이용동의CheckedRelay
			.bind(with: self) { owner, isChecked in
				owner.presenter.set개인정보수집및이용동의Button(isChecked: isChecked)
			}
			.disposeOnDeactivate(interactor: self)
		
		termsOfUseViewModel.is마케팅정보수신동의CheckedRelay
			.bind(with: self) { owner, isChecked in
				owner.presenter.set마케팅정보수신동의Button(isChecked: isChecked)
			}
			.disposeOnDeactivate(interactor: self)
		
		termsOfUseViewModel.is위치정보수집및이용동의CheckedRelay
			.bind(with: self) { owner, isChecked in
				owner.presenter.set위치정보수집및이용동의Button(isChecked: isChecked)
			}
			.disposeOnDeactivate(interactor: self)
		
		termsOfUseViewModel.isConfirmButtonEnabledRelay
			.bind(with: self) { owner, isChecked in
				owner.presenter.setConfirmButton(isEnabled: isChecked)
			}
			.disposeOnDeactivate(interactor: self)
	}
}
