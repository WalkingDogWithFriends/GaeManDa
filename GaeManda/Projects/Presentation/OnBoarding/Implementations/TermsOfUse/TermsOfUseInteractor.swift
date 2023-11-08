import RIBs
import OnBoarding
import UseCase

protocol TermsOfUseRouting: ViewableRouting {
	func attachTermsBottomSheet(type: BottomSheetType, with terms: String?)
	func detachTermsBottomSheet()
}

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
	private let useCase: TermsofUseUseCase
	
	init(presenter: TermsOfUsePresentable, useCase: TermsofUseUseCase) {
		self.useCase = useCase
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
		if !termsOfUseViewModel.termsOfUseReadState.is전체동의Read {
			router?.attachTermsBottomSheet(
				type: .a약관전체동의,
				with: termsOfUseViewModel.termsOfUse?.allAgreement
			)
		} else {
			termsOfUseViewModel.termsButtonDidTap(type: .a약관전체동의)
		}
	}
	
	func a이용약관동의ButtonDidTap() {
		if !termsOfUseViewModel.termsOfUseReadState.is이용약관Read {
			router?.attachTermsBottomSheet(
				type: .a이용약관동의,
				with: termsOfUseViewModel.termsOfUse?.useAgreement
			)
		} else {
			termsOfUseViewModel.termsButtonDidTap(type: .a이용약관동의)
		}
	}
	
	func a개인정보수집및이용동의ButtonDidTap() {
		if !termsOfUseViewModel.termsOfUseReadState.is개인정보수집및이용Read {
			router?.attachTermsBottomSheet(
				type: .a개인정보수집및이용동의,
				with: termsOfUseViewModel.termsOfUse?.personalInformationAgreement
			)
		} else {
			termsOfUseViewModel.termsButtonDidTap(type: .a개인정보수집및이용동의)
		}
	}
	
	func a위치정보수집및이용동의DidTap() {
		if !termsOfUseViewModel.termsOfUseReadState.is위치정보수집및이용Read {
			router?.attachTermsBottomSheet(
				type: .a위치정보수집및이용동의,
				with: termsOfUseViewModel.termsOfUse?.locationAgreement
			)
		} else {
			termsOfUseViewModel.termsButtonDidTap(type: .a위치정보수집및이용동의)
		}
	}
	
	func a마케팅정보수신동의DidTap() {
		if !termsOfUseViewModel.termsOfUseReadState.is마케팅정보수신Read {
			router?.attachTermsBottomSheet(
				type: .a마케팅정보수신동의,
				with: termsOfUseViewModel.termsOfUse?.marketingAgreement
			)
		} else {
			termsOfUseViewModel.termsButtonDidTap(type: .a마케팅정보수신동의)
		}
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
		
		/// 약관가져오기
		useCase.fetchTerms()
			.subscribe(
				with: self,
				onSuccess: { owner, termsOfUse in
					owner.termsOfUseViewModel.termsOfUse = termsOfUse
				},
				onFailure: { _, error in
					debugPrint(error.localizedDescription)
				}
			)
			.disposeOnDeactivate(interactor: self)
	}
}

// MARK: - TermsBottomSheetListener
extension TermsOfUseInteractor {
	func termsBottomSheetDismiss() {
		router?.detachTermsBottomSheet()
	}
	
	func termsBottomSheetDidFinish(type: BottomSheetType) {
		router?.detachTermsBottomSheet()
		termsOfUseViewModel.termsButtonDidTap(type: type)
	}
}
