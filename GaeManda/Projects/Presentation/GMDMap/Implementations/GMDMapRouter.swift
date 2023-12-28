//
//  GMDMapRouter.swift
//  GMDMapImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDMap

protocol GMDMapInteractable: Interactable {
	var router: GMDMapRouting? { get set }
	var listener: GMDMapListener? { get set }
}

protocol GMDMapViewControllable: ViewControllable { }

final class GMDMapRouter:
	ViewableRouter<GMDMapInteractable, GMDMapViewControllable>,
	GMDMapRouting {
	private let mapUserBuildable: MapUserBuildable
	private var mapUserRouter: ViewableRouting?
	
	init(
		interactor: GMDMapInteractable,
		viewController: GMDMapViewControllable,
		mapUserBuildable: MapUserBuildable
	) {
		self.mapUserBuildable = mapUserBuildable
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}

// MARK: - MapUserBuildable
extension GMDMapRouter {
	func attachMapUser(with mapUser: [GMDMapViewModel]) {
//		if let 
	}
	
	func detachMapUser() {
		
	}
}
