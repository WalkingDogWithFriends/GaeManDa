//
//  Chatting.swift
//  Chatting
//
//  Created by jung on 2023/08/18.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

public protocol ChattingBuildable: Buildable {
	func build(withListener listener: ChattingListener) -> ViewableRouting
}

public protocol ChattingListener: AnyObject {
	func chattingDidTapBackButton()
	func didTapLeaveChatting()
}
