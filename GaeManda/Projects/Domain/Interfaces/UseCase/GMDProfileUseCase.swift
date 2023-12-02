//
//  GMDProfileUseCase.swift
//  UseCase
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import RxSwift
import Entity
import Repository

public protocol GMDProfileUseCase {
	init(
		dogRepository: DogRepository,
		userRepository: UserRepository
	)
	
	func fetchDogs() -> Single<[Dog]>
	func fetchUser() -> Single<User>
	func updateUser(_ user: User, isProfileImageChanged: Bool) -> Single<Void>
	
	func updateDog(_ dog: Dog, isProfileImageChanged: Bool) -> Single<Void>
	func createDog(_ dog: Dog) -> Single<Void>
	func fetchDogCharacters() -> Single<[DogCharacter]>
	func fetchDogSpecies() -> Single<[String]>
}
