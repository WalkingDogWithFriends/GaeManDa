//
//  PassTouchesScrollViewDelegate.swift
//  GMDUtils
//
//  Created by jung on 10/20/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

public protocol PassTouchesScrollViewDelegate: AnyObject {
	func scrollViewTouchBegan(_ touches: Set<UITouch>, with event: UIEvent?)
	func scrollViewTouchMoved(_ touches: Set<UITouch>, with event: UIEvent?)
	func scrollViewTouchEnded(_ touches: Set<UITouch>, with event: UIEvent?)
}

public extension PassTouchesScrollViewDelegate where Self: UIViewController {
	func scrollViewTouchBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.touchesBegan(touches, with: event)
	}
	
	func scrollViewTouchMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.touchesMoved(touches, with: event)
	}
	
	func scrollViewTouchEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.touchesEnded(touches, with: event)
	}
}
