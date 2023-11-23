import RIBs
import CorePresentation
import DesignKit
import GMDUtils
import OnBoarding

public protocol DogSettingDependency: Dependency {
	var dogSettingViewController: ViewControllable { get }
	var birthdayPickerBuildable: BirthdayPickerBuildable { get }
}

final class DogSettingComponent:
	Component<DogSettingDependency>,
	FirstDogSettingDependency,
	SecondDogSettingDependency {
	fileprivate var dogSettingViewController: ViewControllable {
		return dependency.dogSettingViewController
	}
	
	var birthdayPickerBuildable: BirthdayPickerBuildable {
		return dependency.birthdayPickerBuildable
	}
}

public final class DogSettingBuilder: Builder<DogSettingDependency>, DogSettingBuildable {
	public override init(dependency: DogSettingDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: DogSettingListener) -> Routing {
		let component = DogSettingComponent(dependency: dependency)
		let interactor = DogSettingInteractor()
		interactor.listener = listener
		
		let firstDogSettingBuildable = FirstDogSettingBuilder(dependency: component)
		let secondDogSettingBuildable = SecondDogSettingBuilder(dependency: component)
		
		return DogSettingRouter(
			interactor: interactor,
			viewController: component.dogSettingViewController,
			firstDogSettingBuildable: firstDogSettingBuildable,
			secondDogSettingBuildable: secondDogSettingBuildable
		)
	}
}
