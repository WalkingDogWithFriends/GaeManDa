import RIBs
import Utils

public protocol DogSettingBuildable: Buildable {
	func build(
		withListener listener: DogSettingListener,
		navigationControllerable: NavigationControllerable?
	) -> Routing
}

public protocol DogSettingListener: AnyObject {
	func dogSettingDidFinish()
	func dogSettingBackButtonDidTap()
}
