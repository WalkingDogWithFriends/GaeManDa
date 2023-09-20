//
//  SignInResponseDTO.swift
//  DTO
//
//  Created by jung on 2023/09/18.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct SignInResponseDTO: Decodable {
	public let token: String
	public let userDidSignIn: Bool
	
	public init(token: String, userDidSignIn: Bool) {
		self.token = token
		self.userDidSignIn = userDidSignIn
	}
}

#if DEBUG
extension SignInResponseDTO {
	public static let stubData =
	"""
	{
		"token": "111",
		"userDidSignIn": true
	}
	"""
}
#endif
