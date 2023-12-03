//
//  GeocodeDataMapper.swift
//  DataMapper
//
//  Created by jung on 12/2/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import Entity

public protocol GeocodeDataMapper {
	func mapToLocation(latitude: String, longitude: String) -> Location
}

public struct GeocodeDataMapperImpl: GeocodeDataMapper {
	public init() {}
	
	public func mapToLocation(latitude: String, longitude: String) -> Location {
		return Location(
			latitude: (latitude as NSString).doubleValue,
			longitude: (longitude as NSString).doubleValue
		)
	}
}
