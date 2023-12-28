//
//  GMDMapRouter.swift
//  GMDMapImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDMap

protocol GMDMapInteractable: Interactable, MapUserListener {
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
		if mapUserRouter != nil { return }
		let group = mapUser.map(\.mapDog)
		let router = mapUserBuildable.build(withListener: interactor, group: group)
		self.mapUserRouter = router
		attachChild(router)
		viewControllable.present(
			router.viewControllable,
			animated: false,
			modalPresentationStyle: .overFullScreen
		)
	}
	
	func detachMapUser() {
		guard let router = mapUserRouter else { return }
		detachChild(router)
		self.mapUserRouter = nil
	}
}
