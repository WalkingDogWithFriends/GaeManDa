import RIBs

public protocol SignInBuildable: Buildable {
	func build(withListener listener: SignInListener) -> ViewableRouting
}

public protocol SignInListener: AnyObject {
	func didSignIn(isFirst: Bool)
}
