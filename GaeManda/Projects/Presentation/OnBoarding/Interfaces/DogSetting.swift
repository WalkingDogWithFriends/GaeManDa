import RIBs
import GMDUtils

public protocol DogProfileSettingBuildable: Buildable {
	func build(withListener listener: DogProfileSettingListener) -> Routing
}

public protocol DogProfileSettingListener: AnyObject {
	func dogProfileSettingDidFinish()
	func dogProfileSettingBackButtonDidTap()
	func dogProfileSettingDismiss()
}
