//
//  DogRepositoryImpl.swift
//  DTO
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import RxSwift
import DataMapper
import DTO
import Entity
import GMDNetwork
import Repository

public struct DogRepositoryImpl: DogRepository {
	private let dogDataMapper: DogDataMapper
	
	public init(dogDataMapper: DogDataMapper) {
		self.dogDataMapper = dogDataMapper
	}
	
	public func fetchDogs(id: Int) -> Single<[Dog]> {
		return  Provider<DogAPI>
			.init(stubBehavior: .immediate)
			.request(DogAPI.fetchDogs(id: id), type: [DogResponseDTO].self)
			.map { $0.map { dogDataMapper.mapToDog(from: $0) } }
	}
	
	public func updateDog(dog: Dog) -> Single<Void> {
		return Provider<DogAPI>
			.init(stubBehavior: .immediate)
			.request(DogAPI.updateDogs(dog: dog), type: VoidResponse.self)
			.map { _ in }
	}
	
	public func postNewDog(dog: Dog) -> Single<Void> {
		return Provider<DogAPI>
			.init(stubBehavior: .immediate)
			.request(DogAPI.postNewDog(dog: dog), type: VoidResponse.self)
			.map { _ in }
	}
}
