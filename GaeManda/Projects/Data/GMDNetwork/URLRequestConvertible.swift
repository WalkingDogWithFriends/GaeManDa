//
//  URLRequestConvertible.swift
//  DTO
//
//  Created by 김영균 on 2023/07/02.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public protocol URLRequestConvertible {
	func asURLRequest() throws -> URLRequest
}

extension URLRequestConvertible {
	public var urlRequest: URLRequest? { try? asURLRequest() }
}

extension URLRequest: URLRequestConvertible {
	public func asURLRequest() throws -> URLRequest { self }
}
