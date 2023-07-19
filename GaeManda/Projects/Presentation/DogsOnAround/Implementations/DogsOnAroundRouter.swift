//
//  DogsOnAroundRouter.swift
//  DogsOnAroundImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import DogsOnAround

protocol DogsOnAroundInteractable: Interactable {
    var router: DogsOnAroundRouting? { get set }
    var listener: DogsOnAroundListener? { get set }
}

protocol DogsOnAroundViewControllable: ViewControllable { }

final class DogsOnAroundRouter:
	ViewableRouter<DogsOnAroundInteractable, DogsOnAroundViewControllable>,
		DogsOnAroundRouting {
    override init(
			interactor: DogsOnAroundInteractable,
			viewController: DogsOnAroundViewControllable
		) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
