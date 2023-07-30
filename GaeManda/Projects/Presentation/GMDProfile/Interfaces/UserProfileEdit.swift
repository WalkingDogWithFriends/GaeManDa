//
//  UserProfileEdit.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

public protocol UserProfileEditBuildable: Buildable {
	func build(withListener listener: UserProfileEditListener) -> ViewableRouting
}

public protocol UserProfileEditListener: AnyObject {
	func userProfileEditBackButtonDidTap()
}
