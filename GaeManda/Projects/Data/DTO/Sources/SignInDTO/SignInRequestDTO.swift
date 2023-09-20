//
//  SignInRequestDTO.swift
//  DTO
//
//  Created by jung on 2023/09/18.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public enum LoginType: String {
	case kakao
	case apple
}

public struct SignInRequestDTO: Encodable {
	public let token: String
	public let loginType: String
	
	public init(token: String, loginType: LoginType) {
		self.token = token
		self.loginType = loginType.rawValue
	}
}
