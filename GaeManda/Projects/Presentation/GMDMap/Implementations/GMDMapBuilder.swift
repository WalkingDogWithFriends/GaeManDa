//
//  GMDMapBuilder.swift
//  GMDMapImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDMap

public protocol GMDMapDependency: Dependency { }

final class GMDMapComponent: Component<GMDMapDependency> { }

public final class GMDMapBuilder:
	Builder<GMDMapDependency>,
	GMDMapBuildable {
	public override init(dependency: GMDMapDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: GMDMapListener) -> ViewableRouting {
		let viewController = GMDMapViewController()
		let interactor = GMDMapInteractor(presenter: viewController)
		interactor.listener = listener
		return GMDMapRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
