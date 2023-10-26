//
//  Helpers.swift
//  GMDExtensions
//
//  Created by 김영균 on 10/26/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import CoreLocation
import RxCocoa
import RxSwift

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
	guard let returnValue = object as? T else {
		throw RxCocoaError.castingError(object: object, targetType: resultType)
	}
	return returnValue
}

public typealias CLAuthorizationEvent = (manager: CLLocationManager, status: CLAuthorizationStatus)
func clAuthorizationStatus(_ args: [Any]) throws -> CLAuthorizationEvent {
	let manager = try castOrThrow(CLLocationManager.self, args[0])
	let rawValue = manager.authorizationStatus.rawValue
	guard let status = CLAuthorizationStatus.init(rawValue: rawValue) else {
		throw RxCocoaError.castingError(object: args[1], targetType: CLAuthorizationStatus.self)
	}
	return (manager, status)
}

public typealias CLLocationsEvent = (manager: CLLocationManager, locations: [CLLocation])
func clLocationsEvent(_ args: [Any]) throws -> CLLocationsEvent {
	let manager = try castOrThrow(CLLocationManager.self, args[0])
	let locations = try castOrThrow(Array<CLLocation>.self, args[1])
	return (manager, locations)
}

public typealias CLErrorEvent = (manager: CLLocationManager, error: Error)
func clErrorEvent(_ args: [Any]) throws -> CLErrorEvent {
	let manager = try castOrThrow(CLLocationManager.self, args[0])
	let error = try castOrThrow(Error.self, args[1])
	return (manager, error)
}
