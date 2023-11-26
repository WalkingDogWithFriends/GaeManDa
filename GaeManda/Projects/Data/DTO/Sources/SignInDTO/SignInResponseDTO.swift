//
//  SignInResponseDTO.swift
//  DTO
//
//  Created by jung on 2023/09/18.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct SignInResponseDTO: Decodable {
	public let accessToken: String
	public let refreshToken: String
	
	public init(
		accessToken: String,
		refreshToken: String
	) {
		self.accessToken = accessToken
		self.refreshToken = refreshToken
	}
}

#if DEBUG
extension SignInResponseDTO {
	public static let stubData =
	"""
	{
		"accessToken": "111",
		"refreshToken": "111"
	}
	"""
}
#endif
