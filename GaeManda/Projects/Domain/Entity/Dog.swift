//
//  Dog.swift
//  Entity
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public enum Sex: String {
	case male = "남"
	case female = "여"
}

public struct Dog {
	public let name: String
	public let sex: String
	public let age: String
	public let weight: String
	public let didNeutered: Bool
	
	public init(
		name: String,
		sex: String,
		age: String,
		weight: String,
		didNeutered: Bool
	) {
		self.name = name
		self.sex = sex
		self.age = age
		self.weight = weight
		self.didNeutered = didNeutered
	}
}
