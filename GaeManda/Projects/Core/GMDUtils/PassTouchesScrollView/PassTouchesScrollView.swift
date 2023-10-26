//
//  PassTouchesScrollView.swift
//  GMDExtensions
//
//  Created by jung on 10/20/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

open class PassTouchesScrollView: UIScrollView {
	public weak var touchesDelegate: PassTouchesScrollViewDelegate?
	
	// MARK: - Initializers
	public init() {
		super.init(frame: .zero)
		
		self.gestureRecognizers?.forEach {
			$0.cancelsTouchesInView = false
			$0.delaysTouchesBegan = false
			$0.delaysTouchesEnded = false
		}
	}
	
	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError()
	}
	
	override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		touchesDelegate?.scrollViewTouchBegan(touches, with: event)
	}
	
	override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		touchesDelegate?.scrollViewTouchMoved(touches, with: event)
	}
	
	override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		touchesDelegate?.scrollViewTouchEnded(touches, with: event)
	}
}
