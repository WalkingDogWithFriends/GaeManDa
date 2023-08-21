//
//  Message.swift
//  Entity
//
//  Created by jung on 2023/08/21.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

public struct Message {
	public let message: String
	public let nickName: String
	public let profileImage: UIImage?
	public let date: String
	
	public init(
		message: String,
		nickName: String,
		profileImage: UIImage?,
		date: String
	) {
		self.message = message
		self.nickName = nickName
		self.profileImage = profileImage
		self.date = date
	}
}
