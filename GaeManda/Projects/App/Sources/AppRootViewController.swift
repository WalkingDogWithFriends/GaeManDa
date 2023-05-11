import RIBs
import UIKit

protocol AppRootPresentableListener: AnyObject {
	// TODO: Declare properties and methods that the view controller can invoke to perform
	// business logic, such as signIn(). This protocol is implemented by the corresponding
	// interactor class.
}

final class AppRootViewController:
	UIViewController,
	AppRootPresentable,
	AppRootViewControllable {
	weak var listener: AppRootPresentableListener?
	
	override func viewDidLoad() {
		self.view.backgroundColor = .systemPink
	}
}
