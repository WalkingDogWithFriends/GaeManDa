//
//  UserAPI.swift
//  DTO
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import DTO
import Entity
import GMDNetwork

enum UserAPI {
	case fetchUser(id: Int)
	/// nickName, age, sex
	case updateUser(String, Int, String)
}

extension UserAPI: TargetType {
	public var baseURL: URL {
		return URL(string: "http://117.17.198.45:8000/api/member")!
	}
	
	public var path: String {
		switch self {
			case .fetchUser, .updateUser:
				return "/profile"
		}
	}
	
	public var method: HTTPMethod {
		switch self {
			case .fetchUser:
				return .get
			case .updateUser:
				return .patch
		}
	}
	
	public var task: TaskType {
		switch self {
			case .fetchUser:
				return .requestPlain
				
			case let .updateUser(nickName, age, sex):
				let requestDTO = UserProfilePatchReqeustDTO(
					nickname: nickName,
					birthday: "\(age)",
					gender: sex,
					profileImage: Data(),
					isFileChange: false
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
			case .fetchUser:
				let jsonString = UserProfileResponseDTO.stubData
				let data = jsonString.data(using: .utf8)
				
				return data ?? Data()
				
			case .updateUser:
				return Data()
		}
	}
}
