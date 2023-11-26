//
//  OnBoardingUseCase.swift
//  UseCase
//
//  Created by jung on 11/26/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import RxSwift
import Entity
import Repository

public protocol OnBoardingUseCase {
	init(
		dogRepository: DogRepository,
		userRepository: UserRepository
	)
	
	func createDogs(_ dog: Dog) -> Single<Void>
	func fetchDogCharacters() -> Single<[DogCharacter]>
	func fetchDogSpecies() -> Single<[String]>
}
