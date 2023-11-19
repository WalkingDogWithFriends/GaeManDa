//
//  DogCharacterPickerBuilder.swift
//  CorePresentation
//
//  Created by jung on 11/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import CorePresentation
import UseCase

public protocol DogCharacterPickerDependency: Dependency {
	var gmdProfileUseCase: GMDProfileUseCase { get }
}

final class DogCharacterPickerComponent:
	Component<DogCharacterPickerDependency>,
	DogCharacterPickerInteractorDependency {
	var gmdProfileUseCase: GMDProfileUseCase {
		return dependency.gmdProfileUseCase
	}
}

public final class DogCharacterPickerBuilder:
	Builder<DogCharacterPickerDependency>,
	DogCharacterPickerBuildable {
	public override init(dependency: DogCharacterPickerDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(
		withListener listener: DogCharacterPickerListener,
		selectedId: [Int]?
	) -> ViewableRouting {
		let component = DogCharacterPickerComponent(dependency: dependency)
		let viewController = DogCharacterPickerViewController()
		
		let interactor = DogCharacterPickerInteractor(
			presenter: viewController,
			dependency: component,
			selectedId: selectedId
		)
		interactor.listener = listener
		return DogCharacterPickerRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
