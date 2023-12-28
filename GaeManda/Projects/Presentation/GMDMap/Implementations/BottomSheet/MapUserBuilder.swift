//
//  MapUserBuilder.swift
//  GMDMap
//
//  Created by jung on 12/28/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

public protocol MapUserDependency: Dependency { }

final class MapUserComponent: Component<MapUserDependency> { }

// MARK: - Builder
protocol MapUserBuildable: Buildable {
	func build(
		withListener listener: MapUserListener,
		group: [MapDog]
	) -> ViewableRouting
}

final class MapUserBuilder: Builder<MapUserDependency>, MapUserBuildable {
	override init(dependency: MapUserDependency) {
		super.init(dependency: dependency)
	}
	
	func build(
		withListener listener: MapUserListener,
		group: [MapDog]
	) -> ViewableRouting {
		let viewController = MapUserViewController()
		let interactor = MapUserInteractor(presenter: viewController)
		interactor.listener = listener
		return MapUserRouter(interactor: interactor, viewController: viewController)
	}
}
