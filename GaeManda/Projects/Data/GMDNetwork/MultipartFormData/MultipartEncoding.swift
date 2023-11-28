//
//  MultipartEncoding.swift
//  LocalStorage
//
//  Created by jung on 11/29/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct MultipartEncoding: ParameterEncoding {
	public static var httpBody: MultipartEncoding { return MultipartEncoding() }
	
	private var randomBoundary: String {
		"Boundary-\(UUID().uuidString)"
	}
	
	public func encode(
		_ urlRequest: URLRequestConvertible,
		with parameters: Parameters?
	) throws -> URLRequest {
		var urlRequest = try urlRequest.asURLRequest()
		
		guard let parameters = parameters else { return urlRequest }
		
		let boundary = randomBoundary
		
		let (properties, images) = convertToMultipartFormDataType(parameters)
		let multiPartBody = createBodyData(properties: properties, file: images, boundary: boundary)
		
		urlRequest.headers.update(.contentType("multipart/form-data; boundary=\(boundary)"))
		urlRequest.httpBody = multiPartBody.bodyData as Data
		
		return urlRequest
	}
}

// MARK: - MultipartFormDataEncoding
private extension MultipartFormDataEncoding {
	func convertToMultipartFormDataType(_ parameters: Parameters) -> (properties: MultipartFormDataType, images: MultipartFormDataType) {
		var properties = [String: Any]()
		var images = [String: Data]()
		
		parameters.forEach { key, value in
			if let value = value as? Data {
				images.updateValue(value, forKey: key)
			} else {
				properties.updateValue(value, forKey: key)
			}
		}
		
		return (.properties(properties), .images(images))
		
	}
	
	func createBodyData(
		properties: MultipartFormDataType,
		file: MultipartFormDataType,
		boundary: String
	) -> MultipartFormDataBody {
		let multipartFormDataBody = MultipartFormDataBody(boundary: boundary)
		multipartFormDataBody.append(properties)
		multipartFormDataBody.append(file)
		multipartFormDataBody.appendBoundary(at: .suffix)
		
		return multipartFormDataBody
	}
}
