//
//  UpdateUserReqeustDTO.swift
//  DTO
//
//  Created by jung on 2023/08/25.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct UpdateUserReqeustDTO: Encodable {
	public let nickName: String
	public let age: Int
	public let sex: String
	
	public init(
		nickName: String,
		age: Int,
		sex: String
	) {
		self.nickName = nickName
		self.age = age
		self.sex = sex
	}
}
