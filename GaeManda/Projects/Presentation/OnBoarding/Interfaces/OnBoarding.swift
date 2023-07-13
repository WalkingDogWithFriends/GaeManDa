import RIBs

public protocol OnBoardingBuildable: Buildable {
	func build(withListener listener: OnBoardingListener) -> Routing
}

public protocol OnBoardingListener: AnyObject {
	func onBoardingDidFinish()
}
