// swiftlint: disable identifier_name
//
//  GeocodeResponseDTO.swift
//  DTO
//
//  Created by 김영균 on 10/31/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct GeocodeResponseDTO: Decodable {
	public let status: String
	public let errorMessage: String?
	public let meta: GeocodeMetaResponseDTO?
	public let addresses: [GeocodeAddressResponseDTO]?
}

public struct GeocodeMetaResponseDTO: Decodable {
	public let totalCount: Int?
	public let page: Int?
	public let count: Int?
}

public struct GeocodeAddressResponseDTO: Decodable {
	public let roadAddress: String?
	public let jibunAddress: String?
	public let englishAddress: String?
	public let addressElements: [GeocodeAddressElementResponseDTO]?
	public let x: String?
	public let y: String?
	public let distance: Double?
}

public struct GeocodeAddressElementResponseDTO: Decodable {
	public let types: [String]?
	public let longName: String?
	public let shortName: String?
	public let code: String?
}
// swiftlint: enable identifier_name
