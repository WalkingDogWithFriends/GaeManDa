//
//  FetchUserResponseDTO.swift
//  LocalStorage
//
//  Created by jung on 12/1/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct FetchUserResponseDTO: Decodable {
	public let memberId: Int
	public let nickname: String
	public let profileImageURL: String // 이미지 파일명
	public let gender: String
	public let birthday: String // yyyyMMdd
	public let latitude: Double
	public let longitude: Double
	
	enum CodingKeys: String, CodingKey {
		case memberId
		case nickname
		case profileImageURL = "profileImage"
		case gender
		case birthday
		case latitude, longitude
	}
	
	public init(
		memberId: Int,
		nickname: String,
		profileImageURL: String,
		gender: String,
		birthday: String,
		latitude: Double,
		longitude: Double
	) {
		self.memberId = memberId
		self.nickname = nickname
		self.profileImageURL = profileImageURL
		self.gender = gender
		self.birthday = birthday
		self.latitude = latitude
		self.longitude = longitude
	}
}

#if DEBUG
extension FetchUserResponseDTO {
	public static let stubData =
 """
 {
 "memberId": 1,
 "nickname": "thrdud0423",
 "profileImage": "",
 "gender": "M",
 "birthday": "19980130",
 "latitude": 0.0,
 "longitude": 0.0,
 }
 """
}
#endif
