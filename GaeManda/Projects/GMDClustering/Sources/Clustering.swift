//
//  Clustering.swift
//  GMDClustering
//
//  Created by jung on 11/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

import Foundation

public protocol ClusteringDelegate<DataType>: AnyObject {
	associatedtype DataType: ClusterData
	
	func didFinishClustering(with results: [ClusterResult<DataType>])
}

public final class Clustering<DataType: ClusterData> {
	// MARK: - Properties
	public weak var delegate: (any ClusteringDelegate<DataType>)?
	
	private let queue: OperationQueue = {
		let queue = OperationQueue()
		queue.underlyingQueue = .global(qos: .userInteractive)
		queue.qualityOfService = .userInteractive
		
		return queue
	}()
	
	// MARK: - Intializer
	public init() { }
}

// MARK: - Run Methods
extension Clustering {
	/// KMeans를 실행합니다. `maxIteration`을 통해 최대 실행횟수를 지정할 수 있으며,
	/// `kRange`를 통해 k값의 범위를 지정할 수 있습니다.
	/// default는 `maxIteration = 20`, `kRange = (2..<9)`입니다
	/// 시간 복잡도 : `O(KN)`
	public func run(
		data: [DataType],
		maxIterations: Int = 20,
		kRange: Range<Int> = (2..<10)
	) {
		queue.cancelAllOperations()
		
		let kMeansResults = kRange
			.filter { $0 <= data.count && $0 >= 2 }
			.map { k -> KMeans in
			let kMeans = KMeans(k: k, data: data, maxIterations: maxIterations)
			queue.addOperation(kMeans)
			return kMeans
		}
		
		queue.addBarrierBlock { [weak self] in
			guard
				let self,
				let optimalKmeans = self.getOptimalClustering(kMeansResults)
			else {
				return
			}
			DispatchQueue.main.async {
				let clusterResults = self.convertToClusterResults(optimalKmeans.clusters)
				self.delegate?.didFinishClustering(with: clusterResults)
			}
		}
	}
	
	/// Optimal한 Clustering을 리턴합니다.
	private func getOptimalClustering(_ kMeansResults: [KMeans<DataType>]) -> KMeans<DataType>? {
		kMeansResults.max(by: { $0.silhouetteScore < $1.silhouetteScore })
	}
	
	private func convertToClusterResults(_ clusters: [Cluster<DataType>]) -> [ClusterResult<DataType>] {
		clusters
			.filter { !$0.group.isEmpty }
			.map { ClusterResult(centroid: $0.centroid, group: $0.group.allValues()) }
	}
}
