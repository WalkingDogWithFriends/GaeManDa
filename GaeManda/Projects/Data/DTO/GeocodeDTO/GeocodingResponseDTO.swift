//
//  GeocodingResponseDTO.swift
//  DTO
//
//  Created by 김영균 on 10/31/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

// swiftlint: disable identifier_name
import Foundation

public struct GeocodingResponseDTO: Decodable {
	public let status: String
	public let errorMessage: String?
	public let meta: GeocodingMetaResponseDTO?
	public let addresses: [GeocodingAddressResponseDTO]?
}

public struct GeocodingMetaResponseDTO: Decodable {
	public let totalCount: Int?
	public let page: Int?
	public let count: Int?
}

public struct GeocodingAddressResponseDTO: Decodable {
	public let roadAddress: String?
	public let jibunAddress: String?
	public let englishAddress: String?
	public let addressElements: [GeocodingAddressElementResponseDTO]?
	public let x: String?
	public let y: String?
	public let distance: Double?
}

public struct GeocodingAddressElementResponseDTO: Decodable {
	public let types: [String]?
	public let longName: String?
	public let shortName: String?
	public let code: String?
}
// swiftlint: enable identifier_name
