import RIBs
import OnBoarding
import UseCase

public protocol TermsOfUseDependency: Dependency {
	var termsOfUseUseCase: TermsofUseUseCase { get }
}

final class TermsOfUseComponent: Component<TermsOfUseDependency>, TermsBottomSheetDependency {
	var termsBottomSheetBuildable: TermsBottomSheetBuildable {
		TermsBottomSheetBuilder(dependency: self)
	}
	
	fileprivate var termsOfUseUseCase: TermsofUseUseCase {
		dependency.termsOfUseUseCase
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
		let interactor = TermsOfUseInteractor(presenter: viewController, useCase: component.termsOfUseUseCase)
		interactor.listener = listener
		return TermsOfUseRouter(
			interactor: interactor,
			viewController: viewController,
			termsBottomSheetBuildable: component.termsBottomSheetBuildable
		)
	}
}
