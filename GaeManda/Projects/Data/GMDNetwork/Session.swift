//
//  Session.swift
//  DTO
//
//  Created by 김영균 on 2023/07/02.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public protocol Sessionable {
	func request(request: URLRequest) async throws -> Data
}

public struct Session: Sessionable {
	private let session: URLSession
	private var interceptor: Interceptor?
	
	public init(
		session: URLSession = URLSession(configuration: .default),
		interceptor: Interceptor? = nil
	) {
		self.session = session
		self.interceptor = interceptor
	}
	
	public func request(request: URLRequest) async throws -> Data {
		var request = request
		
		if let interceptor = self.interceptor {
			request = interceptor.adapt(request)
		}
		
		let (data, response) = try await self.session.data(for: request)
		
		guard let httpResponse = response as? HTTPURLResponse else {
			throw NetworkError.networkFailed(reason: .httpNoResponse)
		}
		
		switch httpResponse.statusCode {
		case 400..<500:
			throw NetworkError.networkFailed(reason: .clientError(errorCode: httpResponse.statusCode))
		
		case 500..<600:
			throw NetworkError.networkFailed(reason: .serverError(errorCode: httpResponse.statusCode))
		
		default:
			break
		}
		
		return data
	}
}
