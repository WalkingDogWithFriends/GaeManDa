import RIBs
import Entity

public protocol UserProfileSettingBuildable: Buildable {
	func build(withListener listener: UserProfileSettingListener) -> ViewableRouting
}

public protocol UserProfileSettingListener: AnyObject {
	func userProfileSettingDidFinish(with passingModel: UserProfileSettingPassingModel)
	func userProfileSettingBackButtonDidTap()
	func userProfileSettingDismiss()
}
