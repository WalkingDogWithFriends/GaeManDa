//
//  Font.swift
//  DesignKit
//
//  Created by 김영균 on 2023/08/27.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import GMDExtensions

public extension String {
	func titlelg(color: UIColor = .black) -> NSAttributedString {
		return attributedString(
			font: UIFont.b20,
			color: color,
			lineSpacing: 0,
			lineHeightMultiple: 0.75
		)
	}
	
	func textlg(color: UIColor = .black) -> NSAttributedString {
		return attributedString(
			font: UIFont.r16,
			color: color,
			lineSpacing: -0.5
		)
	}
	
	func textmg(color: UIColor = .black) -> NSAttributedString {
		return attributedString(
			font: UIFont.r13,
			color: color,
			lineSpacing: -0.5,
			lineHeightMultiple: 0.88
		)
	}
	
	func inputText(color: UIColor = .black) -> NSAttributedString {
		return attributedString(
			font: UIFont.r15,
			color: color,
			lineSpacing: -0.4,
			lineHeightMultiple: 0.77
		)
	}
	
	func caption(color: UIColor = .black) -> NSAttributedString {
		return attributedString(
			font: UIFont.r12,
			color: color,
			lineSpacing: -0.4,
			lineHeightMultiple: 0.95
		)
	}
}
