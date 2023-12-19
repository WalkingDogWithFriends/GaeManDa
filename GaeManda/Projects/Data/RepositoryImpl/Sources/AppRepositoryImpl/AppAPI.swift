//
//  AppAPI.swift
//  LocalStorage
//
//  Created by 김영균 on 12/18/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import DTO
import GMDNetwork

public enum AppAPI {
	case registerDeviceToken(_ dto: RegisterDeviceTokenRequestDTO)
}

extension AppAPI: TargetType {
	public var baseURL: URL {
		return URL(string: "http://117.17.198.45:8000")!
	}
	
	public var path: String {
		switch self {
		case .registerDeviceToken:
			return "/memeber/deviceToken"
		}
	}
	
	public var method: HTTPMethod {
		switch self {
		case .registerDeviceToken:
			return .post
		}
	}
	
	public var task: TaskType {
		switch self {
		case .registerDeviceToken(let dto):
			return .requestJSONEncodable(dto)
		}
	}
	
	public var headers: HTTPHeaders {
		return .default
	}
	
	public var sampleData: Data {
		return Data()
	}
}
