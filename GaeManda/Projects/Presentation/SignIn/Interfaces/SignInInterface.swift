import RIBs

public protocol SignInListener: AnyObject { }

public protocol SignInBuildable: Buildable {
	func build(withListener listener: SignInListener) -> ViewableRouting
}
