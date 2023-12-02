//
//  DogProfileSecondSettingPassingModel.swift
//  OnBoarding
//
//  Created by jung on 12/2/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import GMDUtils

public struct DogProfileSecondSettingPassingModel {
	public let species: String
	public let isNeutered: Bool
	public let characterIds: [Int]
	public let profileImage: UIImageWrapper
	
	public init(
		species: String,
		isNeutered: Bool,
		characterIds: [Int],
		profileImage: UIImageWrapper
	) {
		self.species = species
		self.isNeutered = isNeutered
		self.characterIds = characterIds
		self.profileImage = profileImage
	}
}
