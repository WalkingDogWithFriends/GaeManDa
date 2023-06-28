import RIBs

public protocol UserSettingBuildable: Buildable {
	func build(withListener listener: UserSettingListener) -> ViewableRouting
}

public protocol UserSettingListener: AnyObject {
	func userSettingDidFinish()
}
