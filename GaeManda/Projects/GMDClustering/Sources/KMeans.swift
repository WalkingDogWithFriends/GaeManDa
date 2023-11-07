//
//  KMeans.swift
//  GMDClustering
//
//  Created by jung on 11/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

final class KMeans<T: ClusterData>: Operation {
	let k: Int
	let data: [T]
	var clusters: [Cluster<T>]
	
	/// KMeans의 최대 Iteration
	var maxIterations: Int

	/// 센트로이드의 이동이 있었는지에 대한 여부.
	private(set) var isChanged: Bool
	
	/// Cluster들의 Centriods
	var centroids: [Location] { clusters.map { $0.centroid } }
	
	private(set) var dbi = Double.greatestFiniteMagnitude
	
	override var isAsynchronous: Bool { true }
	
	// MARK: - Initializers
	init(k: Int, data: [T], maxIterations: Int) {
		self.k = k
		self.data = data
		self.maxIterations = maxIterations
		self.clusters = []
		self.isChanged = false
	}
	
	// MARK: - main Method
	override func main() {
		guard !isCancelled else { return }
		
		run()
		daviesBouldInIndex()
	}
}

// MARK: - run Methods
private extension KMeans {
	func run() {
		initClusters()
		
		var iteration = 0
		
		repeat {
			runIteration(at: &iteration)
		} while isChanged && (iteration < maxIterations) && !isCancelled
	}
	
	func initClusters() {
		let initCenteroids = randomCenteroids(count: k, data: data)
		
		self.clusters = generateClusters(centroids: initCenteroids)

		run(operations: classifyDataToNearestCluster, updateCentroids)
	}
	
	func runIteration(at iteration: inout Int) {
		run(operations: updateGroups, updateCentroids)
		iteration += 1
	}
	
	func run(operations: (() -> Void)...) {
		guard !isCancelled else { return }
		self.queuePriority = QueuePriority(rawValue: k + 4) ?? .high
		
		operations.forEach { $0() }
	}
}

// MARK: - Setup methods
private extension KMeans {
	/// 랜덤하게 `k`만큼 centroid를 지정합니다.
	func randomCenteroids(count: Int, data: [T]) -> [T] {
		guard data.count > count else { return data }
		
		guard let firstData = data.first else { return [] }
		
		if count == 1 { return [firstData] }
		
		var result = [firstData]
		let diff = data.count / (count - 1)
		
		(1..<count).forEach { result.append(data[$0 * diff - 1]) }
		
		return result
	}
	
	/// Cluster를 생성합니다.
	func generateClusters(centroids: [T]) -> [Cluster<T>] {
		return centroids.map { Cluster(centroid: $0.location) }
	}
	
	/// 각 data들을 가장 가까운 클러스터에 `insert`합니다.
	func classifyDataToNearestCluster() {
		data.forEach { neareastCluster(from: $0).insert($0) }
	}
}

// MARK: - Update Method
private extension KMeans {
	/// Centroid를 업데이트 합니다.
	func updateCentroids() {
		clusters.forEach { $0.updateCentroid() }
	}
	
	/// data들을 가장 가까운 클러스터로 업데이트합니다.
	func updateGroups() {
		isChanged = false
		
		clusters.forEach { cluster in
			cluster.group.allValues()
				.map { ($0, neareastCluster(from: $0)) }
				.filter { cluster != $1 }
				.forEach {
					isChanged = true
					$1.insert($0)
					cluster.remove($0)
				}
		}
	}
	
	/// 해당 location으로 부터 가장 가까운 Cluster를 리턴합니다.
	func neareastCluster(from data: T) -> Cluster<T> {
		var minDistance = Double.greatestFiniteMagnitude
		var nearestClusterIndex = 0
		
		clusters.enumerated().forEach { index, cluster in
			let distance = cluster.centroid.distance(with: data.location)
			
			if distance < minDistance {
				nearestClusterIndex = index
				minDistance = distance
			}
		}

		return clusters[nearestClusterIndex]
	}
}

// MARK: DBI Method
extension KMeans {
	func daviesBouldInIndex() {
		var sum: Double = 0
		let deviations = clusters.map { $0.deviation() }
		
		for i in 0..<clusters.count {
			var maxValue: Double = 0
			for j in 0..<clusters.count where i != j {
				let sumOfDevations = deviations[i] + deviations[j]
				
				let distanceCenters = clusters[i].centroid.distance(with: clusters[j].centroid)
				
				maxValue = max(maxValue, sumOfDevations / distanceCenters)
			}
			
			sum += maxValue
		}
		
		dbi = sum / Double(clusters.count)
	}
}
