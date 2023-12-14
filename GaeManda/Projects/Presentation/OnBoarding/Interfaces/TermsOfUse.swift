import RIBs

public protocol TermsOfUseBuildable: Buildable {
	func build(withListener listener: TermsOfUseListener) -> ViewableRouting
}

public protocol TermsOfUseListener: AnyObject {
	func termsOfUseDidFinish(with is마케팅정보수신동의Checked: Bool)
}
