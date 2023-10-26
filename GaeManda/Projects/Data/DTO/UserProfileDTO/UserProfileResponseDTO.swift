//
//  UserProfileResponseDTO.swift
//  DTO
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct UserProfileResponseDTO: Decodable {
	public let memberId: Int
	public let nickname: String
	public let profileImage: String // 이미지 파일명
	public let gender: String
	public let age: Int
	public let birthday: String // yyyyMMdd
	
	public init(
		memberId: Int,
		nickname: String,
		profileImage: String,
		gender: String,
		age: Int,
		birthday: String
	) {
		self.memberId = memberId
		self.nickname = nickname
		self.profileImage = profileImage
		self.gender = gender
		self.age = age
		self.birthday = birthday
	}
}

#if DEBUG
extension UserProfileResponseDTO {
	public static let stubData =
 """
 {
 "memberId": 1,
 "nickname": "thrdud0423",
 "profileImage": "",
 "gender": "남",
 "age": 26,
 "birthday": "19980130"
 }
 """
}
#endif
