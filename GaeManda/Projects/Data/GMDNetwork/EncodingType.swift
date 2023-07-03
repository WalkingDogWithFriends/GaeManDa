//
//  EncodingType.swift
//  DTO
//
//  Created by 김영균 on 2023/07/02.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public enum EncodingType {
	case jsonBody
	case queryString
}

public extension EncodingType {
	func encode(
		_ urlRequest: URLRequest,
		with parameters: Parameters?
	) throws -> URLRequest {
		switch self {
		case .jsonBody:
			return try JSONEncoding.httpBody.encode(urlRequest, with: parameters)
			
		case .queryString:
			return try URLEncoding.queryString.encode(urlRequest, with: parameters)
		}
	}
}

public extension Encodable {
	var toDictionary: [String: Any] {
		guard let object = try? JSONEncoder().encode(self) else { return [:] }
		guard let dictionary = try? JSONSerialization.jsonObject(
			with: object,
			options: []
		) as? [String: Any] else {
			return [:]
		}
		return dictionary
	}
}
