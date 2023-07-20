//
//  ProfileUseCaseImpl.swift
//  UseCase
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import RxSwift
import Entity
import UseCase
import Repository

public struct UserProfileUseCaseImpl: UserProfileUseCase {
	public let dogDependency: DogRepository
	
	public init(dogDependecy: DogRepository) {
		self.dogDependency = dogDependecy
	}
	
	public func fetchDogs(id: Int) async -> Single<[Dog]> {
		return await dogDependency.fetchDogs(id: id)
	}
}
