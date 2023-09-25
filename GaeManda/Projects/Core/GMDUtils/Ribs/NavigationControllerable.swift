import UIKit
import RIBs

public final class NavigationControllerable: ViewControllable {
	public var uiviewController: UIViewController { self.navigationController }
	public let navigationController: UINavigationController
	public var navigationBarIsHidden: Bool = false {
		didSet {
			navigationController.isNavigationBarHidden = navigationBarIsHidden
		}
	}
	
	public init(root: ViewControllable) {
		let navigation = UINavigationController(rootViewController: root.uiviewController)
		self.navigationController = navigation
		self.navigationController.navigationBar.isHidden = true
	}
	
	public func pushViewControllerable(
		_ viewControllerable: ViewControllable,
		animated: Bool
	) {
		navigationController.pushViewController(
			viewControllerable.uiviewController,
			animated: animated
		)
	}
	
	public func popViewControllerable(animated: Bool) {
		self.navigationController.popViewController(animated: animated)
	}
}
