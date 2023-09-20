//
//  SignInAPI.swift
//  RepositoryImpl
//
//  Created by jung on 2023/09/16.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import DTO
import Entity
import GMDNetwork

public enum SignInAPI {
	case tryKakaoSignIn(token: String)
}

extension SignInAPI: TargetType {
	public var baseURL: URL { return URL(string: "")! }
	
	public var path: String {
		return "login"
	}
	
	public var method: HTTPMethod {
		switch self {
		case .tryKakaoSignIn:
			return .post
		}
	}
	
	public var task: TaskType {
		switch self {
		case let .tryKakaoSignIn(token):
			let requestDTO = SignInRequestDTO(
				token: token,
				loginType: .kakao
			)
			
			return .requestParameters(
				parameters: requestDTO.toDictionary,
				encoding: .jsonBody
			)
		}
	}
	
	public var headers: HTTPHeaders {
		return .default
	}
	
	public var sampleData: Data {
		switch self {
		case .tryKakaoSignIn:
			let jsonString = SignInResponseDTO.stubData
			let data = jsonString.data(using: .utf8)
			
			return data ?? Data()
		}
	}
}
