//
//  DogsCarouselViewModel.swift
//  GMDProfile
//
//  Created by jung on 2023/09/05.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Entity
import GMDUtils

struct DogsCarouselViewModel {
	var dogs: [DogCellViewModel] = []
	
	/// 강아지의 원래 갯수
	var dogsCount: Int {
		dogs.isEmpty ? 0 : dogs.count - 2
	}
}

struct DogCellViewModel {
	let dogId: Int
	let profileImageURL: String
	let name: String
	let gender: Gender
	let age: Int
	let weight: Int
	let isNeutered: Bool
	
	var dogTitle: String { "\(name) (\(gender.genderKR) / \(age)세)" }
	
	var dogIsNeutered: String { isNeutered ? "했어요" : "안 했어요" }
}

extension DogCellViewModel {
	init(_ dog: Dog) {
		self.dogId = dog.id
		self.profileImageURL = dog.profileImage
		self.name = dog.name
		self.gender = dog.gender
		self.age = dog.age
		self.weight = dog.weight
		self.isNeutered = dog.isNeutered
	}
}
