import RIBs
import GMDUtils

public protocol DogSettingBuildable: Buildable {
	func build(withListener listener: DogSettingListener) -> Routing
}

public protocol DogSettingListener: AnyObject {
	func dogSettingDidFinish()
	func dogSettingBackButtonDidTap()
	func dogSettingDismiss()
}
