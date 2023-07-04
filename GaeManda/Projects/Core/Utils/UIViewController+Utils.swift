import UIKit

public extension UIViewController {
	func setupBackNavigationButton(
		target: Any?,
		action: Selector?
	) {
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(
				systemName: "chevron.backward",
				withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
			),
			style: .plain,
			target: target,
			action: action
		)
		navigationItem.leftBarButtonItem?.tintColor = .black
	}
}
