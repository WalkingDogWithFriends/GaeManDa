//
//  SignInRequestDTO.swift
//  DTO
//
//  Created by jung on 2023/09/18.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

public struct SignInRequestDTO: Encodable {
	public let accessToken: String
	
	public init(accessToken: String) {
		self.accessToken = accessToken
	}
}
