import RIBs

public protocol TermsOfUseBuildable: Buildable {
	func build(withListener listener: TermsOfUseListener) -> ViewableRouting
}

public protocol TermsOfUseListener: AnyObject {
	func termsOfUseDidFinish()
}
