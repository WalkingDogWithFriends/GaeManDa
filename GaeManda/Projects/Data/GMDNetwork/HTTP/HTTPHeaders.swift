//
//  HTTPHeaders.swift
//  DTO
//
//  Created by 김영균 on 2023/07/02.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct HTTPHeaders {
	private var headers: [HTTPHeader]
	
	public init() {
		self.headers = []
	}
	
	public init(_ headers: [HTTPHeader]) {
		self.init()
		headers.forEach { update($0) }
	}
	
	public init(_ dictionary: [String: String]) {
		self.init()
		dictionary.forEach { update(HTTPHeader(name: $0.key, value: $0.value)) }
	}
	
	public mutating func add(name: String, value: String) {
		update(HTTPHeader(name: name, value: value))
	}
	
	public mutating func add(_ header: HTTPHeader) {
		update(header)
	}
	
	public mutating func update(name: String, value: String) {
		update(HTTPHeader(name: name, value: value))
	}
	
	public mutating func update(_ header: HTTPHeader) {
		guard let index = headers.index(of: header.name) else {
			headers.append(header)
			return
		}
		headers.replaceSubrange(index...index, with: [header])
	}
	
	public mutating func remove(name: String) {
		guard let index = headers.index(of: name) else { return }
		headers.remove(at: index)
	}
	
	public mutating func sort() {
		headers.sort { $0.name.lowercased() < $1.name.lowercased() }
	}
	
	public func sorted() -> HTTPHeaders {
		var headers = self
		headers.sort()
		return headers
	}
	
	public func value(for name: String) -> String? {
		guard let index = headers.index(of: name) else { return nil }
		return headers[index].value
	}
	
	public subscript(_ name: String) -> String? {
		get { value(for: name) }
		set {
			if let value = newValue {
				update(name: name, value: value)
			} else {
				remove(name: name)
			}
		}
	}
	
	public var dictionary: [String: String] {
		let namesAndValues = headers.map { ($0.name, $0.value) }
		return Dictionary(namesAndValues, uniquingKeysWith: { _, last in last })
	}
}

public extension URLRequest {
	var headers: HTTPHeaders {
		get { allHTTPHeaderFields.map(HTTPHeaders.init) ?? HTTPHeaders() }
		set { allHTTPHeaderFields = newValue.dictionary }
	}
}
