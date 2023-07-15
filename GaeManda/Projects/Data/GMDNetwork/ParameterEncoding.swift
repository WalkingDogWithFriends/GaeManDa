//
//  ParameterEncoding.swift
//  DTO
//
//  Created by 김영균 on 2023/07/02.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoding {
	func encode(
		_ urlRequest: URLRequestConvertible,
		with parameters: Parameters?
	) throws -> URLRequest
}

public struct JSONEncoding: ParameterEncoding {
	private enum Error: Swift.Error {
		case invalidJSONObject
	}
	
	public static var httpBody: JSONEncoding { JSONEncoding() }
	
	public func encode(
		_ urlRequest: URLRequestConvertible,
		with parameters: Parameters?
	) throws -> URLRequest {
		var urlRequest = try urlRequest.asURLRequest()
		
		guard let parameters = parameters else { return urlRequest }
		
		guard JSONSerialization.isValidJSONObject(parameters) else {
			throw NetworkError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: Error.invalidJSONObject))
		}
		
		do {
			let data = try JSONSerialization.data(withJSONObject: parameters)
			if urlRequest.headers["Content-Type"] == nil {
				urlRequest.headers.update(.contentType("application/json"))
			}
			urlRequest.httpBody = data
		} catch {
			throw NetworkError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
		}
		return urlRequest
	}
}

public struct URLEncoding: ParameterEncoding {
	public static var queryString: URLEncoding { URLEncoding() }
	
	public func encode(
		_ urlRequest: URLRequestConvertible,
		with parameters: Parameters?
	) throws -> URLRequest {
		var urlRequest = try urlRequest.asURLRequest()
		
		guard let parameters = parameters else { return urlRequest }
		
		guard let url = urlRequest.url else {
			throw NetworkError.parameterEncodingFailed(reason: .missingURL)
		}
		
		if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
			let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
			urlComponents.percentEncodedQuery = percentEncodedQuery
			urlRequest.url = urlComponents.url
		}
		
		return urlRequest
	}
}

private extension URLEncoding {
	func escape(_ string: String) -> String {
		string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
	}
	
	func query(_ parameters: [String: Any]) -> String {
		var components: [(String, String)] = []
		
		for key in parameters.keys.sorted(by: <) {
			let value = parameters[key]!
			components.append((escape(key), escape("\(value)")))
		}
		
		return components.map { "\($0)=\($1)" }.joined(separator: "&")
	}
}
