//
//  UserProfilePatchReqeustDTO.swift
//  DTO
//
//  Created by jung on 2023/08/25.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct UserProfilePatchReqeustDTO: Encodable {
	public let nickname: String
	public let birthday: String // yyyyMMdd
	public let gender: String
	public let profileImage: Data // 이미지 파일
	public let isFileChange: Bool // 이미지 파일이 그대로인지 아니면 변하는지 확인
	
	public init(
		nickname: String,
		birthday: String,
		gender: String,
		profileImage: Data,
		isFileChange: Bool
	) {
		self.nickname = nickname
		self.birthday = birthday
		self.gender = gender
		self.profileImage = profileImage
		self.isFileChange = isFileChange
	}
}
