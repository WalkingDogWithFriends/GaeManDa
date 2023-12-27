//
//  UserAPI.swift
//  DTO
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import DTO
import GMDNetwork

enum UserAPI {
	case fetchUser
	case updateUser(_ dto: UpdateUserRequestDTO)
	case createUser(_ dto: CreateUserRequestDTO)
	case checkDuplicated(nickName: String)
}

extension UserAPI: TargetType {
	public var baseURL: URL {
		return URL(string: "http://117.17.198.45:9000/api/member")!
	}
	
	public var path: String {
		switch self {
			case .fetchUser, .updateUser, .createUser:
					return "/profile"
			case let .checkDuplicated(nickName):
					return "/duplication/\(nickName)"
		}
	}
	
	public var method: HTTPMethod {
		switch self {
			case .fetchUser, .checkDuplicated:
				return .get
			case .updateUser:
				return .patch
			case .createUser:
				return .post
		}
	}
	
	public var task: TaskType {
		switch self {
			case .fetchUser, .checkDuplicated:
				return .requestPlain
				
			case let .updateUser(requestDTO):
				return .uploadMultipart(parameters: requestDTO.toDictionary)
				
			case let .createUser(requestDTO):
				return .uploadMultipart(parameters: requestDTO.toDictionary)
		}
	}
	
	public var headers: HTTPHeaders {
		return .default
	}
	
	public var sampleData: Data {
		switch self {
			case .fetchUser:
				let jsonString = FetchUserResponseDTO.stubData
				let data = jsonString.data(using: .utf8)
				
				return data ?? Data()
				
			case .updateUser, .createUser, .checkDuplicated:
				return Data()
		}
	}
}
