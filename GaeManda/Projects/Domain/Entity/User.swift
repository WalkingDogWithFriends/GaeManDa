//
//  User.swift
//  Entity
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct User {
	public let id: Int
	public let name: String
	public let gender: Gender
	public let address: Location
	public let birthday: String
	public let profileImage: String
	
	public var age: Int { convertToAge() }

	public init(
		id: Int,
		name: String, 
		gender: Gender,
		address: Location,
		birthday: String,
		profileImage: String
	) {
		self.id = id
		self.name = name
		self.gender = gender
		self.address = address
		self.birthday = birthday
		self.profileImage = profileImage
	}
}

// MARK: - Private Method
private extension User {
	func convertToAge() -> Int {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "ko_KR")
		dateFormatter.dateFormat = "YYYYMMdd"
		
		guard let date = dateFormatter.date(from: birthday) else { return 0 }
		
		let now = Date()
		let ageComponents = Calendar.current.dateComponents([.year], from: date, to: now)
		
		return ageComponents.year ?? 0
	}
}
