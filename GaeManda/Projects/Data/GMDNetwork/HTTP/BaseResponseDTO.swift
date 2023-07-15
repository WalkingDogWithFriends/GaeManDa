//
//  BaseResponseDTO.swift
//  DTO
//
//  Created by 김영균 on 2023/07/02.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

// Server Response Model에 맞게 수정 예정
public struct BaseResponseDTO<ResponseType: Decodable> {
	public let statusCode: Int
	public let message: String
	public let data: ResponseType
	
	public enum CodingKeys: String, CodingKey {
		case statusCode = "status_code"
		case message
		case data
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		statusCode = try container.decode(Int.self, forKey: .statusCode)
		message = try container.decode(String.self, forKey: .message)
		data = try container.decode(ResponseType.self, forKey: .data)
	}
}
