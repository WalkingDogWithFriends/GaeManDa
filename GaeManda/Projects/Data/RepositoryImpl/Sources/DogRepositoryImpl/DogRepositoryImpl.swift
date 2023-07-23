//
//  DogRepositoryImpl.swift
//  DTO
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import RxSwift
import DTO
import Entity
import GMDNetwork
import Repository

public struct DogRepositoryImpl: DogRepository {
	public init() { }
	
	public func fetchDogs(id: Int) async -> Single<[Dog]> {
		return  Provider<DogAPI>
			.init(stubBehavior: .immediate)
			.request(DogAPI.fetchDogs(id: id), type: [DogResponseDTO].self)
			.map { $0.map { $0.toDomain } }
	}
}
