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
import Repository
import UseCase

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
	
	public func fetchDogs(id: Int) -> Single<[Dog]> {
		return dogDependency.fetchDogs(id: id)
	}
	
	public func fetchUser(id: Int) -> Single<User> {
		return userDependency.fetchUser(id: id)
	}
}
