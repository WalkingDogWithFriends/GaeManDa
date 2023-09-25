//
//  UIScrollView+Extension.swift
//  GMDExtensions
//
//  Created by jung on 9/25/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

public enum ScrollDirection {
	case top
	case bottom
}

public extension UIScrollView {
	func scroll(to direction: ScrollDirection, animated: Bool) {
		DispatchQueue.main.async {
			switch direction {
			case .top:
				self.scrollToTop(animated: animated)
			case .bottom:
				self.scrollToBottom(animated: animated)
			}
		}
	}
}

private extension UIScrollView {
	func scrollToTop(animated: Bool) {
		setContentOffset(.zero, animated: animated)
	}
	
	func scrollToBottom(animated: Bool) {
		let bottomOffset = CGPoint(
			x: 0,
			y: contentSize.height - bounds.size.height + contentInset.bottom
		)
		
		guard bottomOffset.y > 0 else { return }
		
		setContentOffset(bottomOffset, animated: animated)
	}
}
