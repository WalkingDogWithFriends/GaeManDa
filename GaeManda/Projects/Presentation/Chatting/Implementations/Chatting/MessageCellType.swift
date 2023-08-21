//
//  ChattingViewModel.swift
//  ChattingImpl
//
//  Created by jung on 2023/08/21.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import Entity

enum MessageCellType {
	case date(_ date: String)
	case receive(message: Message)
	case receiveWithProfileImage(message: Message)
	case send(message: Message)
}
