//
//  GMDProfileEditBuilder.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDProfile
import UseCase

public protocol GMDProfileEditDependency: Dependency {
	var gmdProfileUseCase: GMDProfileUseCase { get }
}

final class GMDProfileEditComponent:
	Component<GMDProfileEditDependency>,
	GMDProfileEditInteractorDependency {
	var gmdProfileUseCase: GMDProfileUseCase {
		dependency.gmdProfileUseCase
	}
}

public final class GMDProfileEditBuilder:
	Builder<GMDProfileEditDependency>,
	GMDProfileEditBuildable {
	public override init(dependency: GMDProfileEditDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: GMDProfileEditListener) -> ViewableRouting {
		let component = GMDProfileEditComponent(dependency: dependency)
		let viewController = GMDProfileEditViewController()
		let interactor = GMDProfileEditInteractor(
			presenter: viewController,
			dependency: component
		)
		
		interactor.listener = listener
		return GMDProfileEditRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
