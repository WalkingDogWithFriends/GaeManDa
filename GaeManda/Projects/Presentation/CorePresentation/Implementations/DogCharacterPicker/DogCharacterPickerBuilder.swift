//
//  DogCharacterPickerBuilder.swift
//  CorePresentation
//
//  Created by jung on 11/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import CorePresentation
import Entity
import UseCase

public protocol DogCharacterPickerDependency: Dependency { }

public final class DogCharacterPickerBuilder:
	Builder<DogCharacterPickerDependency>,
	DogCharacterPickerBuildable {
	public override init(dependency: DogCharacterPickerDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(
		withListener listener: DogCharacterPickerListener,
		dogCharacters: [DogCharacter],
		selectedId: [Int]?
	) -> ViewableRouting {
		let viewController = DogCharacterPickerViewController()
		
		let interactor = DogCharacterPickerInteractor(
			presenter: viewController,
			dogCharacters: dogCharacters,
			selectedId: selectedId
		)
		interactor.listener = listener
		return DogCharacterPickerRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
