//
//  UserResponseDTO.swift
//  DTO
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import Entity

public struct UserResponseDTO: Decodable {
	public let name: String
	public let sex: String
	public let age: String
	
	public var toDomain: User {
		User(
			name: name,
			sex: sex,
			age: age
		)
	}
}

#if DEBUG
extension UserResponseDTO {
	public static let stubData =
	"""
	{
		"name": "thrdud0423",
		"sex": "남",
		"age": "26"
	}
	"""
}
#endif
