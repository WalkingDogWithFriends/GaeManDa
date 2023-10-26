//
//  NewDogProfileBuilder.swift
//  GMDProfile
//
//  Created by jung on 2023/09/05.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDProfile
import UseCase

public protocol NewDogProfileDependency: Dependency {
	var gmdProfileUseCase: GMDProfileUseCase { get }
}

final class NewDogProfileComponent:
	Component<NewDogProfileDependency>,
	NewDogProfileInteractorDependency {
	var gmdProfileUseCase: GMDProfileUseCase {
		dependency.gmdProfileUseCase
	}
}

// MARK: - Builder
public final class NewDogProfileBuilder:
	Builder<NewDogProfileDependency>,
	NewDogProfileBuildable {
	public override init(dependency: NewDogProfileDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: NewDogProfileListener) -> ViewableRouting {
		let component = NewDogProfileComponent(dependency: dependency)
		let viewController = NewDogProfileViewController()
		let interactor = NewDogProfileInteractor(
			presenter: viewController,
			dependency: component
		)
		interactor.listener = listener
		
		return NewDogProfileRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
