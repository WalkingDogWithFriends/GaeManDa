//
//  DogCharacterDashboardBuilder.swift
//  CorePresentation
//
//  Created by jung on 12/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import RxCocoa
import CorePresentation
import Entity

public protocol DogCharacterDashboardDependency: Dependency { }

public final class DogCharacterDashboardBuilder:
	Builder<DogCharacterDashboardDependency>,
	DogCharacterDashboardBuildable {
	public override init(dependency: DogCharacterDashboardDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(
		withListener listener: DogCharacterDashboardListener,
		selectedCharacters: BehaviorRelay<[DogCharacter]>
	) -> ViewableRouting {
		let viewController = DogCharacterDashboardViewController()
		let interactor = DogCharacterDashboardInteractor(
			presenter: viewController,
			selectedCharacters: selectedCharacters
		)
		interactor.listener = listener
		return DogCharacterDashboardRouter(interactor: interactor, viewController: viewController)
	}
}
