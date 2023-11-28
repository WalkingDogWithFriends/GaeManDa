//
//  TargetType.swift
//  DTO
//
//  Created by 김영균 on 2023/07/02.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public protocol TargetType: URLRequestConvertible {
	var baseURL: URL { get }
	var path: String { get }
	var method: HTTPMethod { get }
	var task: TaskType { get }
	var headers: HTTPHeaders { get }
	var sampleData: Data { get }
}

extension TargetType {
	public func asURLRequest() throws -> URLRequest {
		var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
		urlRequest.httpMethod = method.rawValue
		urlRequest.allHTTPHeaderFields = headers.dictionary
		urlRequest = try addParameter(to: urlRequest)
		return urlRequest
	}
	
	private func addParameter(to request: URLRequest) throws -> URLRequest {
		var request = request
		
		switch task {
		case .requestPlain:
			break
			
		case let .requestJSONEncodable(parameters):
			request.httpBody = try JSONEncoder().encode(parameters)
			
		case let .requestCustomJSONEncodable(parameters, encoder):
			request.httpBody = try encoder.encode(parameters)
			
		case let .requestParameters(parameters, encoding):
			request = try encoding.encode(request, with: parameters)
			
		case let .requestCompositeParameters(query, body):
			request = try EncodingType.queryString.encode(request, with: query)
			request = try EncodingType.jsonBody.encode(request, with: body)
			
		case let.uploadMultipart(parameters):
			request = try EncodingType.multipartFormData.encode(request, with: parameters)
		}
		
		return request
	}
}
