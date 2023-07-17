//
//  UserProfile.swift
//  ProfileImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

public protocol UserProfileBuildable: Buildable {
	func build(withListener listener: UserProfileListener) -> ViewableRouting
}

public protocol UserProfileListener: AnyObject { }
