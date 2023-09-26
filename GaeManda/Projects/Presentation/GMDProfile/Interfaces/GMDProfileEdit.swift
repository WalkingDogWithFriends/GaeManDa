//
//  GMDProfileEdit.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

public protocol GMDProfileEditBuildable: Buildable {
	func build(withListener listener: GMDProfileEditListener) -> ViewableRouting
}

public protocol GMDProfileEditListener: AnyObject {
	func gmdProfileEditDidTapBackButton()
	func gmdProfileEditDismiss()
	func gmdProfileEndEditing()
}
