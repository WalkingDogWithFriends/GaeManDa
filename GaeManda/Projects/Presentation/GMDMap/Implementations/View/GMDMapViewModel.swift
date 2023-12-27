//
//  GMDMapViewModel.swift
//  GMDMapImpl
//
//  Created by jung on 12/27/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import GMDClustering

struct GMDMapViewModel: ClusterData {
	let location: Location
	let mapDog: MapDog
	
	init(location: Location, mapDog: MapDog) {
		self.location = location
		self.mapDog = mapDog
	}
}

struct MapDog: Equatable {
	let profileImageURL: String
	let name: String
	let age: String
	let gender: String
	let character: String
}
