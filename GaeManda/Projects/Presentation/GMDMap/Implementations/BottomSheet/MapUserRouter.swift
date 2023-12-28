//
//  MapUserRouter.swift
//  GMDMap
//
//  Created by jung on 12/28/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

protocol MapUserInteractable: Interactable {
	var router: MapUserRouting? { get set }
	var listener: MapUserListener? { get set }
}

protocol MapUserViewControllable: ViewControllable { }

final class MapUserRouter: ViewableRouter<MapUserInteractable, MapUserViewControllable>, MapUserRouting {
	override init(interactor: MapUserInteractable, viewController: MapUserViewControllable) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
