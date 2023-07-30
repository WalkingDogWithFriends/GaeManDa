//
//  DogProfileEditBuilder.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDProfile

public protocol DogProfileEditDependency: Dependency { }

final class DogProfileEditComponent: Component<DogProfileEditDependency> { }

public final class DogProfileEditBuilder:
	Builder<DogProfileEditDependency>,
	DogProfileEditBuildable {
	public override init(dependency: DogProfileEditDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: DogProfileEditListener) -> ViewableRouting {
		let component = DogProfileEditComponent(dependency: dependency)
		let viewController = DogProfileEditViewController()
		let interactor = DogProfileEditInteractor(presenter: viewController)
		interactor.listener = listener
		return DogProfileEditRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
