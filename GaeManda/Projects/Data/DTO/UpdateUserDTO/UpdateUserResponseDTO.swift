//
//  UpdateUserResponseDTO.swift
//  DTO
//
//  Created by jung on 2023/08/25.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct UpdateUserResponseDTO: Decodable {
	public let message: String
	
	public init(message: String) {
		self.message = message
	}
}

#if DEBUG
extension UpdateUserResponseDTO {
	public static let stubData =
	"""
	{
		"message": "success"
	}
	"""
}
#endif
