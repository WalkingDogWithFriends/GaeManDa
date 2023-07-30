//
//  DogProfileEdit.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

public protocol DogProfileEditBuildable: Buildable {
	func build(withListener listener: DogProfileEditListener) -> ViewableRouting
}

public protocol DogProfileEditListener: AnyObject { }
