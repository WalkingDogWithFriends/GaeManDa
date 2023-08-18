//
//  Chatting.swift
//  ChattingImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

public protocol ChattingListBuildable: Buildable {
		func build(withListener listener: ChattingListListener) -> ViewableRouting
}

public protocol ChattingListListener: AnyObject { }
