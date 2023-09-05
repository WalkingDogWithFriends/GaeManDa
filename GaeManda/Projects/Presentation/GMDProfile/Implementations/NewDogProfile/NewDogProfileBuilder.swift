//
//  NewDogProfileBuilder.swift
//  GMDProfile
//
//  Created by jung on 2023/09/05.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDProfile

public protocol NewDogProfileDependency: Dependency { }

final class NewDogProfileComponent: Component<NewDogProfileDependency> { }

// MARK: - Builder
public final class NewDogProfileBuilder:
	Builder<NewDogProfileDependency>,
	NewDogProfileBuildable {
	public override init(dependency: NewDogProfileDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: NewDogProfileListener) -> ViewableRouting {
		let viewController = NewDogProfileViewController()
		let interactor = NewDogProfileInteractor(presenter: viewController)
		interactor.listener = listener
		return NewDogProfileRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
