//
//  DogCharacterPicker.swift
//  CorePresentation
//
//  Created by jung on 11/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import Entity

public protocol DogCharacterPickerBuildable: Buildable {
	func build(
		withListener listener: DogCharacterPickerListener,
		dogCharacters: [DogCharacter],
		selectedId: [Int]?
	) -> ViewableRouting
}

public protocol DogCharacterPickerListener: AnyObject {
	func dogCharactersSelected(_ dogCharacters: [DogCharacter])
	func dogCharacterPickerDismiss()
}
