import RIBs

public protocol UserProfileSettingBuildable: Buildable {
	func build(withListener listener: UserProfileSettingListener) -> ViewableRouting
}

public protocol UserProfileSettingListener: AnyObject {
	func userProfileSettingDidFinish()
	func userProfileSettingBackButtonDidTap()
	func userProfileSettingDismiss()
}
