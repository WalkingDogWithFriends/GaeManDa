//
//  DogsOnAroundBuilder.swift
//  DogsOnAroundImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import DogsOnAround

public protocol DogsOnAroundDependency: Dependency { }

final class DogsOnAroundComponent: Component<DogsOnAroundDependency> { }

public final class DogsOnAroundBuilder:
	Builder<DogsOnAroundDependency>,
	DogsOnAroundBuildable {
	public override init(dependency: DogsOnAroundDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: DogsOnAroundListener) -> ViewableRouting {
		let viewController = DogsOnAroundViewController()
		let interactor = DogsOnAroundInteractor(presenter: viewController)
		interactor.listener = listener
		return DogsOnAroundRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
