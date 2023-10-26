//
//  User.swift
//  Entity
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct User: Codable {
	public let name: String
	public let sex: Sex
	public let age: String
	public let image: Data?
	
	public init(name: String, sex: Sex, age: String) {
		self.name = name
		self.sex = sex
		self.age = age
		self.image = nil
	}
	
	public init(name: String, sex: Sex, age: String, image: Data?) {
		self.name = name
		self.sex = sex
		self.age = age
		self.image = image
	}
}

public extension User {
	static let defaultUser = User(name: "", sex: .male, age: "")
}
