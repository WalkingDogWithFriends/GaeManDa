import RIBs
import OnBoarding

protocol TermsOfUseInteractable: Interactable, TermsBottomSheetListener {
	var router: TermsOfUseRouting? { get set }
	var listener: TermsOfUseListener? { get set }
}

protocol TermsOfUseViewControllable: ViewControllable { }

final class TermsOfUseRouter:
	ViewableRouter<TermsOfUseInteractable, TermsOfUseViewControllable>,
	TermsOfUseRouting {
	private let termsBottomSheetBuildable: TermsBottomSheetBuildable
	private var termsBottomSheetRouting: ViewableRouting?
	
	init(
		interactor: TermsOfUseInteractable,
		viewController: TermsOfUseViewControllable,
		termsBottomSheetBuildable: TermsBottomSheetBuildable
	) {
		self.termsBottomSheetBuildable = termsBottomSheetBuildable
		super.init(
			interactor: interactor,
			viewController: viewController
		)
		interactor.router = self
	}
}

// MARK: - TermsBottomSheet
extension TermsOfUseRouter: TermsBottomSheetRouting {
	func attachTermsBottomSheet(type: BottomSheetType, with terms: String) {
		guard termsBottomSheetRouting == nil else { return }
		let router = termsBottomSheetBuildable.build(withListener: interactor, type: type, terms: terms)
		self.termsBottomSheetRouting = router
		attachChild(router)
		viewControllable.present(router.viewControllable, animated: false, modalPresentationStyle: .overFullScreen)
	}
	
	func detachTermsBottomSheet() {
		guard let router = termsBottomSheetRouting else { return }
		detachChild(router)
		self.termsBottomSheetRouting = nil
	}
}
