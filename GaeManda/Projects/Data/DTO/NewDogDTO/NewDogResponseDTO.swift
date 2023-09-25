//
//  NewDogResponseDTO.swift
//  DTO
//
//  Created by jung on 2023/09/10.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct NewDogResponseDTO: Decodable {
	public let message: String
	
	public init(message: String) {
		self.message = message
	}
}

#if DEBUG
extension NewDogResponseDTO {
	public static let stubData =
	"""
	{
		"message": "success"
	}
	"""
}
#endif
