//
//  UIView+Extension.swift
//  GMDExtensions
//
//  Created by 김영균 on 2023/08/14.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

public extension UIView {
	/// The identifier for the view. (ex: `MyView.identifier`)	
	static var identifier: String {
		String(describing: self)
	}
	
	/// Adds multiple subviews to the view.
	/// - Parameter views: The views to add as subviews. (ex: `view.addSubviews(view1, view2, view3)`)
	func addSubviews(_ views: UIView...) {
		for view in views {
			addSubview(view)
		}
	}
}
