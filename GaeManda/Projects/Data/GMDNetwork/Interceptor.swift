//
//  Interceptor.swift
//  LocalStorage
//
//  Created by 김영균 on 11/26/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import LocalStorage

public protocol Interceptor {
	func adapt(_ request: URLRequest) -> URLRequest
}

public struct RequesetInterceptor: Interceptor {
	public init() {}
	
	public func adapt(_ request: URLRequest) -> URLRequest {
		var urlRequest = request
		do {
			let accessToken = try KeyChainStorage.shared.getAccessToken()
			urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
			return urlRequest
		} catch {
			return urlRequest
		}
	}
}
