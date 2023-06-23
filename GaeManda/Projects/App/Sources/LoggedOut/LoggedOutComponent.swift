import RIBs
import Utils
import OnBoardingImpl
import OnBoarding

final class LoggedOutComponent: Component<LoggedOutDependency> {
	var loggedOutViewController: ViewControllable {
		dependency.loggedOutViewController
	}
}
