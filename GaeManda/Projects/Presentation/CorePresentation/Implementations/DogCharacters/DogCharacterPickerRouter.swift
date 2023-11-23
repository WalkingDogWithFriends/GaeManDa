//
//  DogCharacterPickerRouter.swift
//  CorePresentation
//
//  Created by jung on 11/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import CorePresentation

protocol DogCharacterPickerInteractable: Interactable {
	var router: DogCharacterPickerRouting? { get set }
	var listener: DogCharacterPickerListener? { get set }
}

protocol DogCharacterPickerViewControllable: ViewControllable { }

final class DogCharacterPickerRouter:
	ViewableRouter<DogCharacterPickerInteractable,
	DogCharacterPickerViewControllable>,
		DogCharacterPickerRouting {
	override init(
		interactor: DogCharacterPickerInteractable,
		viewController: DogCharacterPickerViewControllable
	) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
