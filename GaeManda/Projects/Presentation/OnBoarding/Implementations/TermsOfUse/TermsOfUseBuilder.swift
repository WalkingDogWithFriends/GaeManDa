import RIBs
import OnBoarding

public protocol TermsOfUseDependency: Dependency {}

final class TermsOfUseComponent: Component<TermsOfUseDependency>, TermsBottomSheetDependency {
	var termsBottomSheetBuildable: TermsBottomSheetBuildable {
		TermsBottomSheetBuilder(dependency: self)
	}
}

public final class TermsOfUseBuilder:
	Builder<TermsOfUseDependency>,
	TermsOfUseBuildable {
	public override init(dependency: TermsOfUseDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: TermsOfUseListener) -> ViewableRouting {
		let component = TermsOfUseComponent(dependency: dependency)
		let viewController = TermsOfUseViewController()
		let interactor = TermsOfUseInteractor(presenter: viewController)
		interactor.listener = listener
		return TermsOfUseRouter(
			interactor: interactor,
			viewController: viewController,
			termsBottomSheetBuildable: component.termsBottomSheetBuildable
		)
	}
}
