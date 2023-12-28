//
//  GMDMapBuilder.swift
//  GMDMapImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDMap
import GMDUtils

public protocol GMDMapDependency: Dependency, MapUserDependency {
	var locationManagable: CLLocationManagable { get }
}

final class GMDMapComponent: Component<GMDMapDependency> { }

public final class GMDMapBuilder:
	Builder<GMDMapDependency>,
	GMDMapBuildable {
	public override init(dependency: GMDMapDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: GMDMapListener) -> ViewableRouting {
		let component = GMDMapComponent(dependency: dependency)
		let viewController = GMDMapViewController()
		let interactor = GMDMapInteractor(
			presenter: viewController,
			locaitonManagable: component.dependency.locationManagable
		)
		interactor.listener = listener
		
		let mapUserBuildable = MapUserBuilder(dependency: dependency)
		
		return GMDMapRouter(
			interactor: interactor,
			viewController: viewController,
			mapUserBuildable: mapUserBuildable
		)
	}
}
