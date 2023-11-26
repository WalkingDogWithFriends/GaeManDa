//
//  Dog.swift
//  Entity
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct Dog {
	public let id: Int
	public let name: String
	public let profileImage: Data?
	public let species: DogSpecies
	public let gender: Gender
	public let birthday: String
	public let weight: Int
	public let isNeutered: Bool
	public let characterIds: [Int]
	
	public var age: Int { convertToAge() }

	public init(
		id: Int,
		name: String,
		profileImage: Data?,
		species: DogSpecies,
		gender: Gender,
		birthday: String,
		weight: Int,
		isNeutered: Bool,
		characterIds: [Int]
	) {
		self.id = id
		self.name = name
		self.profileImage = profileImage
		self.species = species
		self.gender = gender
		self.birthday = birthday
		self.weight = weight
		self.isNeutered = isNeutered
		self.characterIds = characterIds
	}
}

private extension Dog {
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

// MARK: DogSpecies
public enum DogSpecies: String {
	case MALTESE
	case POODLE
	case POMERANIAN
	case CHIHUAHUA
	case SHIHTZU
	case ETC
	
	public var dogSpeciesKR: String {
		switch self {
			case .MALTESE: return "말티즈"
			case .POODLE: return "푸들"
			case .POMERANIAN: return "포메라니안"
			case .CHIHUAHUA: return "치와와"
			case .SHIHTZU: return "시츄"
			case .ETC: return "기타"
		}
	}
}

public extension DogSpecies {
	init?(krRawValue: String) {
		switch krRawValue {
			case "말티즈": self = .MALTESE
			case "푸들": self = .POODLE
			case "포메라니안": self = .POMERANIAN
			case "치와와": self = .CHIHUAHUA
			case "시츄": self = .SHIHTZU
			case "기타": self = .ETC
			default:
				return nil
		}
	}
}
