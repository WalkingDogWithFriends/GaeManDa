//
//  ClusteringResult.swift
//  GMDClustering
//
//  Created by jung on 11/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct ClusterResult<T: ClusterData> {
	public let centriod: Location
	public let group: [T]
}
