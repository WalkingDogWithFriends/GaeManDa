import RIBs

protocol DogProfileSecondSettingRouting: ViewableRouting { }

protocol DogProfileSecondSettingPresentable: Presentable {
	var listener: DogProfileSecondSettingPresentableListener? { get set }
}

protocol DogProfileSecondSettingListener: AnyObject {
	func dogProfileSecondSettingDidTapConfirmButton()
	func dogProfileSecondSettingDidTaBackButtonp()
	func dogProfileSecondSettingDismiss()
}

final class DogProfileSecondSettingInteractor:
	PresentableInteractor<DogProfileSecondSettingPresentable>,
	DogProfileSecondSettingInteractable,
	DogProfileSecondSettingPresentableListener {
	weak var router: DogProfileSecondSettingRouting?
	weak var listener: DogProfileSecondSettingListener?
	
	override init(presenter: DogProfileSecondSettingPresentable) {
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

// MARK: PresentableListener
extension DogProfileSecondSettingInteractor {
	func didTapConfirmButton() {
		listener?.dogProfileSecondSettingDidTapConfirmButton()
	}
	
	func didTapBackButton() {
		listener?.dogProfileSecondSettingDidTaBackButtonp()
	}
	
	func dismiss() {
		listener?.dogProfileSecondSettingDismiss()
	}
}
