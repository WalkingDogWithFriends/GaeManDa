import RIBs

public protocol AddressSettingBuildable: Buildable {
	func build(withListener listener: AddressSettingListener) -> ViewableRouting
}

public protocol AddressSettingListener: AnyObject {
	func addressSettingDidFinish()
	func addressSettingBackButtonDidTap()
	func addressSettingDidTapSearchTextField()
}
