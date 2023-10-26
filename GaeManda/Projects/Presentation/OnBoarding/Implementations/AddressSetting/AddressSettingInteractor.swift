import RIBs
import OnBoarding

protocol AddressSettingRouting: ViewableRouting {
	func detailAddressSettingAttach()
	func detailAddressSettingDetach()
	func detailAddressSettingDismiss()
}

protocol AddressSettingPresentable: Presentable {
	var listener: AddressSettingPresentableListener? { get set }
    
    func setDetailAddress(_ address: String)
}

final class AddressSettingInteractor:
	PresentableInteractor<AddressSettingPresentable>,
	AddressSettingInteractable,
    AddressSettingPresentableListener {
	weak var router: AddressSettingRouting?
	weak var listener: AddressSettingListener?
	
	override init(presenter: AddressSettingPresentable) {
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
extension AddressSettingInteractor {
	func confirmButtonDidTap() {
		listener?.addressSettingDidFinish()
	}
	
	func backButtonDidTap() {
		listener?.addressSettingBackButtonDidTap()
	}
	
	func dismiss() {
		listener?.addressSettingDismiss()
	}
	
	func loadLocationButtonDidTap() {
		print("loadLocation")
	}
}

extension AddressSettingInteractor {
    func searchTextFieldDidTap() {
        router?.detailAddressSettingAttach()
    }
    
	func addressSettingDidTapSearchTextField() {
		router?.detailAddressSettingAttach()
	}
	
	func detailAddressSettingDidDismiss() {
		router?.detailAddressSettingDismiss()
	}
	
	func detailAddressSettingCloseButtonDidTap() {
		router?.detailAddressSettingDetach()
	}
	
	func detailAddressSettingLoadLocationButtonDidTap(jibunAddress: String) {
        presenter.setDetailAddress(jibunAddress)
		router?.detailAddressSettingDismiss()
	}
}
