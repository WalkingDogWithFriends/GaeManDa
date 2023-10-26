//
//  GMDProfileUseCaseImpl.swift
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

public struct GMDProfileUseCaseImpl: GMDProfileUseCase {
	// MARK: - Repositories
	public let dogDependency: DogRepository
	public let userDependency: UserRepository
	
	// MARK: - Initalizers
	public init(
		dogDependecy: DogRepository,
		userDependency: UserRepository
	) {
		self.dogDependency = dogDependecy
		self.userDependency = userDependency
	}
}
// MARK: - User Profile Use Case
public extension GMDProfileUseCaseImpl {
	func fetchUser(id: Int) -> Single<User> {
		return userDependency.fetchUser(id: id)
	}
	
	func updateUser(
		nickName: String,
		age: Int,
		sex: String
	) -> Single<Void> {
		return userDependency.updateUser(
			nickName: nickName,
			age: age,
			sex: sex
		)
	}
}

// MARK: - Dog Profile Use Case
public extension GMDProfileUseCaseImpl {
	func fetchDogs(id: Int) -> Single<[Dog]> {
		return dogDependency.fetchDogs(id: id)
	}
	
	func updateDog(dog: Dog) -> Single<Void> {
		return dogDependency.updateDog(dog: dog)
	}
	
	func postNewDog(dog: Dog) -> Single<Void> {
		return dogDependency.postNewDog(dog: dog)
	}
}
