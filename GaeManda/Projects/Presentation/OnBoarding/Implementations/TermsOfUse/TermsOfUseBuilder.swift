import RIBs
import OnBoarding
import UseCase

public protocol TermsOfUseDependency: Dependency {
	var onBoardingUseCase: OnBoardingUseCase { get }
}

final class TermsOfUseComponent:
	Component<TermsOfUseDependency>,
	TermsBottomSheetDependency,
	TermsOfUseInteractorDependency {
	var termsBottomSheetBuildable: TermsBottomSheetBuildable {
		TermsBottomSheetBuilder(dependency: self)
	}
	
	var onBoardingUseCase: OnBoardingUseCase { dependency.onBoardingUseCase }
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
		let interactor = TermsOfUseInteractor(
			presenter: viewController,
			dependency: component
		)
		interactor.listener = listener
		return TermsOfUseRouter(
			interactor: interactor,
			viewController: viewController,
			termsBottomSheetBuildable: component.termsBottomSheetBuildable
		)
	}
}
