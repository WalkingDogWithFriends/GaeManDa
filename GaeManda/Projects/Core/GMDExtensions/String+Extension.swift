//
//  String+Extension.swift
//  GMDExtensions
//
//  Created by 김영균 on 2023/08/27.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

public extension String {
	func attributedString(
		font: UIFont,
		color: UIColor,
		lineSpacing: CGFloat = 0,
		lineHeightMultiple: CGFloat? = nil
	) -> NSAttributedString {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = lineSpacing
		var attributes: [NSAttributedString.Key: Any] = [
			.font: font,
			.foregroundColor: color,
			.paragraphStyle: paragraphStyle
		]
		
		if let lineHeightMultiple = lineHeightMultiple {
			paragraphStyle.lineHeightMultiple = lineHeightMultiple
		}
		return NSAttributedString(string: self, attributes: attributes)
	}
}
