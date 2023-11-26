import RIBs
import Entity
import GMDUtils

public protocol DogProfileSettingBuildable: Buildable {
	func build(withListener listener: DogProfileSettingListener) -> Routing
}

public protocol DogProfileSettingListener: AnyObject {
	func dogProfileSettingDidFinish(with dog: Dog)
	func dogProfileSettingBackButtonDidTap()
	func dogProfileSettingDismiss()
}
