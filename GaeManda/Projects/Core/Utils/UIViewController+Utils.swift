import UIKit

public extension UIViewController {
	func setupBackNavigationButton(
		target: Any?,
		action: Selector?
	) {
		if navigationController == nil { return }
		
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
	
	func setupCloseNavigationButton(
		target: Any?,
		action: Selector?
	) {
		if navigationController == nil { return }
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(
				systemName: "xmark",
				withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
			),
			style: .plain,
			target: target,
			action: action
		)
		navigationItem.rightBarButtonItem?.tintColor = .black
	}
}
