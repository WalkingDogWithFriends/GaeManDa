//
//  GeocodingErrorResponseDTO.swift
//  DTO
//
//  Created by 김영균 on 10/31/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

/// 네이버 Geocoding 오류 응답 DTO
public struct GeocodingErrorResponseDTO: Decodable {
	public let error: GeocodingErrorDTO?
	
	public struct GeocodingErrorDTO: Decodable {
		public let message: String?
		public let errorCode: String?
	}
}
