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
	public let userDependency: UserRepository
	
	public init(
		dogDependecy: DogRepository,
		userDependency: UserRepository
	) {
		self.dogDependency = dogDependecy
		self.userDependency = userDependency
	}
	
	public func fetchDogs(id: Int) async -> Single<[Dog]> {
		return await dogDependency.fetchDogs(id: id)
	}
	
	public func fetchUser(id: Int) async -> Single<User> {
		return await userDependency.fetchUser(id: id)
	}
}
