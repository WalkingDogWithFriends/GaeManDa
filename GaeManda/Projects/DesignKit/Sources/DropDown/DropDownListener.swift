//
//  DropDownListener.swift
//  DesignKit
//
//  Created by jung on 10/17/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

public protocol DropDownListener: AnyObject { 
	var dropDownViews: [DropDownView]? { get set }
	
	func hit(at hitView: UIView)
	func registerDropDrownViews(_ dropDownViews: DropDownView...)
	func dropdown(_ dropDown: DropDownView, didSelectRowAt indexPath: IndexPath)
}

public extension DropDownListener where Self: UIViewController {
	func registerDropDrownViews(_ dropDownViews: DropDownView...) {
		self.dropDownViews = dropDownViews
		dropDownViews.forEach { $0.listener = self }
	}
	
	func hit(at hitView: UIView) {
		dropDownViews?.forEach { view in
			if
				view.anchorView === hitView {
				view.isDisplayed.toggle()
			} else {
				view.isDisplayed = false
			}
		}
	}
}
