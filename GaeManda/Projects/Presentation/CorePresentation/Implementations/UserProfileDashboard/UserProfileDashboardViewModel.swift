//
//  UserProfileDashboardViewModel.swift
//  CorePresentation
//
//  Created by jung on 12/15/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import CorePresentation
import Entity

struct UserProfileDashboardViewModel {
	let name: String
	let birthday: String // YYYY.MM.DD
	let gender: Gender
}

extension UserProfileDashboardViewModel {
	init(_ passingModel: UserProfilePassingModel) {
		self.name = passingModel.name
		self.birthday = passingModel.birthday
		self.gender = passingModel.gender
	}
}
