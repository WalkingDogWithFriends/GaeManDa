//
//  DogCharacterPickerBuilder.swift
//  CorePresentation
//
//  Created by jung on 11/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import CorePresentation

protocol DogCharacterPickerDependency: Dependency { }

final class DogCharacterPickerBuilder:
	Builder<DogCharacterPickerDependency>,
	DogCharacterPickerBuildable {
	override init(dependency: DogCharacterPickerDependency) {
		super.init(dependency: dependency)
	}
	
	func build(withListener listener: DogCharacterPickerListener) -> ViewableRouting {
		let viewController = DogCharacterPickerViewController()
		let interactor = DogCharacterPickerInteractor(presenter: viewController)
		interactor.listener = listener
		return DogCharacterPickerRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
