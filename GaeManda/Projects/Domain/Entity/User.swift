//
//  User.swift
//  Entity
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

public struct User {
	public let name: String
	public let sex: Gender
	public let age: String
	
	public init(name: String, sex: Gender, age: String) {
		self.name = name
		self.sex = sex
		self.age = age
	}
}

public extension User {
	static let defaultUser = User(name: "", sex: .male, age: "")
}
