//
//  DogsOnAround.swift
//  DogsOnAroundImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

public protocol DogsOnAroundBuildable: Buildable {
	func build(withListener listener: DogsOnAroundListener) -> ViewableRouting
}

public protocol DogsOnAroundListener: AnyObject { }
