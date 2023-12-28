//
//  MapUserInteractor.swift
//  GMDMap
//
//  Created by jung on 12/28/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

protocol MapUserRouting: ViewableRouting { }

protocol MapUserPresentable: Presentable {
	var listener: MapUserPresentableListener? { get set }
}

protocol MapUserListener: AnyObject { 
	func mapUserDismiss()
}

final class MapUserInteractor:
	PresentableInteractor<MapUserPresentable>,
	MapUserInteractable {
	weak var router: MapUserRouting?
	weak var listener: MapUserListener?
	
	override init(presenter: MapUserPresentable) {
		super.init(presenter: presenter)
		presenter.listener = self
	}
	
	override func didBecomeActive() {
		super.didBecomeActive()
	}
	
	override func willResignActive() {
		super.willResignActive()
	}
}

// MARK: - MapUserPresentableListener
extension MapUserInteractor: MapUserPresentableListener {
	func viewDidLoad() { }
	func dismiss() { }
}
