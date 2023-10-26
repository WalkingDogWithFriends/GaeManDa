//
//  GMDMap.swift
//  GMDMap
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

public protocol GMDMapBuildable: Buildable {
	func build(withListener listener: GMDMapListener) -> ViewableRouting
}

public protocol GMDMapListener: AnyObject { }
