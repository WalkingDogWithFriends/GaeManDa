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
	
	var is약관전체동의Chekced: Bool = false
	var is이용약관동의Checked: Bool = false
	var is개인정보수집및이용동의Checked: Bool = false
	var is위치정보수집및이용동의Checked: Bool = false
	var is마케팅정보수신동의Checked: Bool = false
	var isConfirmButtonEnabled: Bool {
		return is이용약관동의Checked && is개인정보수집및이용동의Checked && is위치정보수집및이용동의Checked
	}
	
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
	
	func a약관전체동의ButtonDidTap() {
		is약관전체동의Chekced.toggle()
		is이용약관동의Checked = is약관전체동의Chekced
		is개인정보수집및이용동의Checked = is약관전체동의Chekced
		is위치정보수집및이용동의Checked = is약관전체동의Chekced
		is마케팅정보수신동의Checked = is약관전체동의Chekced
		self.presenter.set약관전체동의Button(isChecked: is약관전체동의Chekced)
		self.presenter.set이용약관동의Button(isChecked: is이용약관동의Checked)
		self.presenter.set개인정보수집및이용동의Button(isChecked: is개인정보수집및이용동의Checked)
		self.presenter.set위치정보수집및이용동의Button(isChecked: is위치정보수집및이용동의Checked)
		self.presenter.set마케팅정보수신동의Button(isChecked: is마케팅정보수신동의Checked)
		self.presenter.setConfirmButton(isEnabled: isConfirmButtonEnabled)
	}
	
	func a이용약관동의ButtonDidTap() {
		is이용약관동의Checked.toggle()
		is약관전체동의Chekced = isAllChecked()
		self.presenter.set이용약관동의Button(isChecked: is이용약관동의Checked)
		self.presenter.set약관전체동의Button(isChecked: is약관전체동의Chekced)
		self.presenter.setConfirmButton(isEnabled: isConfirmButtonEnabled)
	}
	
	func a개인정보수집및이용동의ButtonDidTap() {
		is개인정보수집및이용동의Checked.toggle()
		is약관전체동의Chekced = isAllChecked()
		self.presenter.set개인정보수집및이용동의Button(isChecked: is개인정보수집및이용동의Checked)
		self.presenter.set약관전체동의Button(isChecked: is약관전체동의Chekced)
		self.presenter.setConfirmButton(isEnabled: isConfirmButtonEnabled)
	}
	
	func a위치정보수집및이용동의DidTap() {
		is위치정보수집및이용동의Checked.toggle()
		is약관전체동의Chekced = isAllChecked()
		self.presenter.set위치정보수집및이용동의Button(isChecked: is위치정보수집및이용동의Checked)
		self.presenter.set약관전체동의Button(isChecked: is약관전체동의Chekced)
		self.presenter.setConfirmButton(isEnabled: isConfirmButtonEnabled)
	}
	
	func a마케팅정보수신동의DidTap() {
		is마케팅정보수신동의Checked.toggle()
		is약관전체동의Chekced = isAllChecked()
		self.presenter.set마케팅정보수신동의Button(isChecked: is마케팅정보수신동의Checked)
		self.presenter.set약관전체동의Button(isChecked: is약관전체동의Chekced)
		self.presenter.setConfirmButton(isEnabled: isConfirmButtonEnabled)
	}
}

private extension TermsOfUseInteractor {
	func isAllChecked() -> Bool {
		return is이용약관동의Checked &&
		is개인정보수집및이용동의Checked &&
		is위치정보수집및이용동의Checked &&
		is마케팅정보수신동의Checked
	}
}
