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
import GMDNetwork

public protocol GMDMapDependency: Dependency {
	var locationManagable: CLLocationManagable { get }
}

final class GMDMapComponent: Component<GMDMapDependency> { 
	fileprivate var webSocket: WebSocket = WebSocketProvider()
}

public final class GMDMapBuilder:
	Builder<GMDMapDependency>,
	GMDMapBuildable {
	public override init(dependency: GMDMapDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: GMDMapListener) -> ViewableRouting {
		let component = GMDMapComponent(dependency: dependency)
		let viewController = GMDMapViewController(webSocket: component.webSocket)
		let interactor = GMDMapInteractor(
			presenter: viewController,
			locaitonManagable: component.dependency.locationManagable
		)
		interactor.listener = listener
		return GMDMapRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
