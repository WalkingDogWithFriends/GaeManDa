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
	public let dogRepository: DogRepository
	public let userRepository: UserRepository
	
	// MARK: - Initalizers
	public init(
		dogRepository: DogRepository,
		userRepository: UserRepository
	) {
		self.dogRepository = dogRepository
		self.userRepository = userRepository
	}
}

// MARK: - User Profile Use Case
public extension GMDProfileUseCaseImpl {
	func fetchUser() -> Single<User> {
		return userRepository.fetchUser()
	}
	
	func updateUser(_ user: User, isProfileImageChanged: Bool) -> Single<Void> {
		return userRepository.updateUser(user, isProfileImageChanged: isProfileImageChanged)
	}
}

// MARK: - Dog Profile Use Case
public extension GMDProfileUseCaseImpl {
	func fetchDogs() -> Single<[Dog]> {
		return dogRepository.fetchDogs()
	}
	
	func updateDog(_ dog: Dog, isProfileImageChanged: Bool) -> Single<Void> {
		return dogRepository.updateDog(dog, isProfileImageChanged: isProfileImageChanged)
	}
	
	func createDog(_ dog: Dog) -> Single<Void> {
		return dogRepository.createDog(dog)
	}
	
	func fetchDogCharacters() -> Single<[DogCharacter]> {
		return dogRepository.fetchDogCharacters()
	}
	
	func fetchDogSpecies() -> Single<[String]> {
		return dogRepository.fetchDogSpecies()
	}
}
