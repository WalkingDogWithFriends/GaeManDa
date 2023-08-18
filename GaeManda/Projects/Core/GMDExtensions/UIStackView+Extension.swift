//
//  UIStackView+Extension.swift
//  GMDExtensions
//
//  Created by 김영균 on 2023/08/11.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

public extension UIStackView {
	/// Adds multiple subviews to the stack view.
	/// - Parameter views: The views to add as subviews. (ex: `view.addArrangedSubviews(view1, view2, view3)`)
	func addArrangedSubviews(_ views: UIView...) {
		for view in views {
			self.addArrangedSubview(view)
		}
	}
}
