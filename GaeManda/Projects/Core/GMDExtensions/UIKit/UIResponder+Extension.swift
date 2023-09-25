//
//  UIResponder+Extension.swift
//  GMDExtensions
//
//  Created by jung on 2023/08/02.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

extension UIResponder {
	private static weak var firstResponder: UIResponder?
	
	public static var currentFirstResponder: UIResponder? {
		firstResponder = nil
		
		// Send action to first responder
		// If target is nil, the app sends the message to the first responder
		UIApplication.shared.sendAction(
			#selector(UIResponder.findFirstResponder(_:)),
			to: nil,
			from: nil,
			for: nil)
		
		return firstResponder
	}
	
	@objc func findFirstResponder(_ sender: Any) {
		// The first responder assigns self to this private var
		UIResponder.firstResponder = self
	}
}
