//
//  DogProfileFirstDashboardViewModel.swift
//  CorePresentation
//
//  Created by jung on 12/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import CorePresentation
import Entity

struct DogProfileFirstDashboardViewModel {
	let name: String
	let birthday: String // YYYY.MM.DD
	let gender: Gender
	let weight: Int
}

extension DogProfileFirstDashboardViewModel {
	init(_ passingModel: DogProfileFirstPassingModel) {
		self.name = passingModel.name
		self.birthday = passingModel.birthday
		self.gender = passingModel.gender
		self.weight = passingModel.weight
	}
}
