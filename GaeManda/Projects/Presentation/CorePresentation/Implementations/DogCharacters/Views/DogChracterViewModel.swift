//
//  DogChracterViewModel.swift
//  CorePresentationImpl
//
//  Created by jung on 11/17/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import Entity

struct DogCharacterViewModel {
	let id: Int
	let character: String
	var isChoice: Bool
}

extension DogCharacterViewModel {
	init(dogCharacter: DogCharacter) {
		self.id = dogCharacter.id
		self.character = dogCharacter.character
		self.isChoice = false
	}
}
