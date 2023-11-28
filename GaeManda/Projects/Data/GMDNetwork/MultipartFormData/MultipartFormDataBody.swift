//
//  MultipartFormDataBody.swift
//  LocalStorage
//
//  Created by jung on 11/29/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

// MARK: - MultipartFormDataType
enum MultipartFormDataType {
	case images([String: Data])
	case properties([String: Any])
}

// MARK: - MultipartFormDataBody
struct MultipartFormDataBody {
	enum BoundaryType {
		case prefix
		case suffix
	}
	
	private let crlf = "\n\r"
	
	var bodyData = NSMutableData()
	private let boundary: String
	
	init(boundary: String) {
		self.boundary = boundary
	}
	
	func append(_ data: MultipartFormDataType) {
		switch data {
			case let .images(parameters):
				append(parameters)
			case let .properties(parameters):
				append(parameters)
		}
	}
	
	/// 일반 property의 경우
	private func append(_ data: [String: Any]) {
		data.forEach { key, value in
			appendBoundary(at: .prefix)
			bodyData.appendString("Content-Disposition: form-data; name=\"\(key)\"")
			bodyData.appendString(crlf)
			bodyData.appendString("\(value)")
			bodyData.appendString(crlf)
		}
	}
	
	/// images 파일의 경우
	private func append(_ data: [String: Data]) {
		data.forEach { key, value in
			appendBoundary(at: .prefix)
			bodyData.appendString("Content-Disposition: form-data; name=\"\(key)\"")
			bodyData.appendString(crlf)
			bodyData.appendString("Content-Type: image/png")
			bodyData.appendString("\(crlf)\(crlf)")
			bodyData.append(value)
			bodyData.appendString(crlf)
		}
	}
	
	func appendBoundary(at type: BoundaryType) {
		switch type {
			case .prefix:
				bodyData.appendString("--\(boundary)\(crlf)")
			case .suffix:
				bodyData.appendString("--\(boundary)--")
		}
	}
}

// MARK: - NSMutableData Extension
extension NSMutableData {
	func appendString(_ string: String) {
		if let data = string.data(using: .utf8) {
			self.append(data)
		}
	}
}
