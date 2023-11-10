//
//  ClusteringResult.swift
//  GMDClustering
//
//  Created by jung on 11/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct ClusterResult<T: ClusterData> {
	/// 클러스터의 Centroid 좌표
	public let centroid: Location
	
	/// 클러스터 내의 데이터
	public let group: [T]
}
