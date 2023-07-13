import RIBs
import OnBoarding

protocol TermsOfUseInteractable: Interactable {
	var router: TermsOfUseRouting? { get set }
	var listener: TermsOfUseListener? { get set }
}

protocol TermsOfUseViewControllable: ViewControllable { }

final class TermsOfUseRouter:
	ViewableRouter<TermsOfUseInteractable, TermsOfUseViewControllable>,
	TermsOfUseRouting {	
	override init(
		interactor: TermsOfUseInteractable,
		viewController: TermsOfUseViewControllable
	) {
		super.init(
			interactor: interactor,
			viewController: viewController
		)
		interactor.router = self
	}
}
