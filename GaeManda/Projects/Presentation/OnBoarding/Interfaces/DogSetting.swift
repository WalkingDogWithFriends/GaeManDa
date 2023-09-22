import RIBs
import GMDUtils

public protocol DogSettingBuildable: Buildable {
	func build(
		withListener listener: DogSettingListener,
		navigationControllerable: NavigationControllerable?
	) -> Routing
}

public protocol DogSettingListener: AnyObject {
	func dogSettingDidFinish()
	func dogSettingBackButtonDidTap()
	func dogSettingDismiss()
}
