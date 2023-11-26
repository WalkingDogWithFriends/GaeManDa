//
//  OnBoardingUseCaseImpl.swift
//  UseCase
//
//  Created by jung on 11/26/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import RxSwift
import Entity
import Repository
import UseCase

public struct OnBoardingUseCaseImpl: OnBoardingUseCase {
	private let dogRepository: DogRepository
	private let userRepository: UserRepository
	
	public init(dogRepository: DogRepository, userRepository: UserRepository) {
		self.dogRepository = dogRepository
		self.userRepository = userRepository
	}
	
	public func createDogs(_ dog: Dog) -> Single<Void> {
		return dogRepository.createDog(dog)
	}
	
	public func fetchDogCharacters() -> Single<[DogCharacter]> {
		return dogRepository.fetchDogCharacters()
	}
	
	public func fetchDogSpecies() -> Single<[String]> {
		return dogRepository.fetchDogSpecies()
	}
}
