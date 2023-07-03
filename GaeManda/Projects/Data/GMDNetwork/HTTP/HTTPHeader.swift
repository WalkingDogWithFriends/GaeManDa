//
//  HTTPHeader.swift
//  DTO
//
//  Created by 김영균 on 2023/07/02.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct HTTPHeader: Hashable {
	public let name: String
	public let value: String
	
	public init(name: String, value: String) {
		self.name = name
		self.value = value
	}
}

extension HTTPHeader: CustomStringConvertible {
	public var description: String {
		"\(name): \(value)"
	}
}

public extension HTTPHeader {
	static func accept(_ value: String) -> HTTPHeader {
		HTTPHeader(name: "Accept", value: value)
	}
	
	static func authorization(bearerToken: String) -> HTTPHeader {
		authorization("Bearer \(bearerToken)")
	}
	
	static func authorization(_ value: String) -> HTTPHeader {
		HTTPHeader(name: "Authorization", value: value)
	}
	
	static func contentType(_ value: String) -> HTTPHeader {
		HTTPHeader(name: "Content-Type", value: value)
	}
}

public extension Array where Element == HTTPHeader {
	func index(of name: String) -> Int? {
		let lowercasedName = name.lowercased()
		return firstIndex { $0.name.lowercased() == lowercasedName }
	}
}

// MARK: - Defaults
extension HTTPHeaders {
	static let `default`: HTTPHeaders = HTTPHeaders([.contentType("application/json")])}
