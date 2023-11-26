//
//  BaseResponse.swift
//  DTO
//
//  Created by 김영균 on 9/25/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public enum BaseResponse {
	public struct ExistData<ResponseType: Decodable>: Decodable {
		public let count: Int?
		public let data: ResponseType
	}
	
	public struct ErrorData: Decodable {
		public var statusCode: Int
		public var error: Error
		
		enum CodingKeys: String, CodingKey {
			case statusCode = "status"
			case error
		}
		
		public init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			statusCode = try container.decode(Int.self, forKey: .statusCode)
			error = try container.decode(BaseResponse.Error.self, forKey: .error)
		}
	}
	
	public struct Error: Decodable {
		public var code: String
		public var detailMessage: String?
	}
}
