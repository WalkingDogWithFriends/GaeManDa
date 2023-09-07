//
//  NewDogProfile.swift
//  GMDProfile
//
//  Created by jung on 2023/09/05.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

public protocol NewDogProfileBuildable: Buildable {
	func build(withListener listener: NewDogProfileListener) -> ViewableRouting
}

public protocol NewDogProfileListener: AnyObject {
	func newDogProfileDidTapBackButton()
	func newDogProfileDidTapConfirmButton()
}
