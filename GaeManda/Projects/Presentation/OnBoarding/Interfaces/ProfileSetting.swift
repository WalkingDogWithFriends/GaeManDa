import RIBs

public protocol ProfileSettingBuildable: Buildable {
	func build(withListener listener: ProfileSettingListener) -> ViewableRouting
}

public protocol ProfileSettingListener: AnyObject { }
