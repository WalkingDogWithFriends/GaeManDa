import UIKit
import RIBs

protocol AppRootPresentableListener: AnyObject { }

final class AppRootViewController:
	UIViewController,
	AppRootPresentable,
	AppRootViewControllable {
	weak var listener: AppRootPresentableListener?
	
	override func viewDidLoad() {
		self.view.backgroundColor = .systemPink
	}
}
