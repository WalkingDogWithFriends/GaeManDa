import Foundation
import RIBs
import CorePresentation
import GMDUtils
import UseCase

protocol DogProfileSecondSettingDependency: Dependency {
	var dogCharacterPickerBuildable: DogCharacterPickerBuildable { get }
	var onBoardingUseCase: OnBoardingUseCase { get }
}

final class DogProfileSecondSettingComponent:
	Component<DogProfileSecondSettingDependency>,
	DogProfileSecondSettingInteractorDependency {
	fileprivate var dogCharacterPickerBuildable: DogCharacterPickerBuildable {
		dependency.dogCharacterPickerBuildable
	}
	
	var useCase: OnBoardingUseCase {
		dependency.onBoardingUseCase
	}
}

protocol DogProfileSecondSettingBuildable: Buildable {
	func build(
		withListener listener: DogProfileSecondSettingListener,
		profileImage: UIImageWrapper
	) -> ViewableRouting
}

final class DogProfileSecondSettingBuilder:
	Builder<DogProfileSecondSettingDependency>,
	DogProfileSecondSettingBuildable {
	override init(dependency: DogProfileSecondSettingDependency) {
		super.init(dependency: dependency)
	}
	
	func build(
		withListener listener: DogProfileSecondSettingListener,
		profileImage: UIImageWrapper
	) -> ViewableRouting {
		let component = DogProfileSecondSettingComponent(dependency: dependency)
		let viewController = DogProfileSecondSettingViewController()
		let interactor = DogProfileSecondSettingInteractor(
			presenter: viewController,
			dependency: component,
			profileImage: profileImage
		)
		interactor.listener = listener
		
		return DogProfileSecondSettingRouter(
			interactor: interactor,
			viewController: viewController,
			dogCharacterPickerBuildable: component.dogCharacterPickerBuildable
		)
	}
}
