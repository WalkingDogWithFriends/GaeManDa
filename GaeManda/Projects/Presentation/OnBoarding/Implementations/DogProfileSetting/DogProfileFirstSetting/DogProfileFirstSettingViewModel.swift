//
//  DogProfileFirstSettingViewModel.swift
//  OnBoardingImpl
//
//  Created by jung on 11/26/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import Entity

struct DogProfileFirstSettingViewModel {
	let name: String
	let birthday: String
	let gender: Gender
	let weight: Int
	let profileImage: Data?
}
