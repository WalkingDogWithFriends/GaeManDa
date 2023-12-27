//
//  RequestInterceptor.swift
//  GaeManda
//
//  Created by 김영균 on 12/19/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import GMDNetwork
import LocalStorage

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
