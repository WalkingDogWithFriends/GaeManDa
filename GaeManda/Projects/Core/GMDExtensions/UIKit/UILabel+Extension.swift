//
//  UILabel+Extension.swift
//  Extensions
//
//  Created by jung on 2023/07/08.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

public extension UILabel {
	func adaptFontSpecificText(_ text: String, specificText: String, font: UIFont) {
		guard let range = text.range(of: specificText) else { return }
		
		let startIndex = text.distance(from: text.startIndex, to: range.lowerBound)
		
		let textAttribute = NSMutableAttributedString.init(string: text)
		textAttribute.setAttributes(
			[
				NSAttributedString.Key.font: font
			],
			range: NSRange(location: startIndex, length: specificText.count)
		)
		
		self.attributedText = textAttribute
	}
}
