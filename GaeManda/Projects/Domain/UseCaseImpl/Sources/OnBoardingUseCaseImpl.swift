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
	private let geocodeRepository: GeocodeRepository
	private let termsRepository: TermsRepository
	
	public init(
		dogRepository: DogRepository,
		userRepository: UserRepository,
		geocodeRepository: GeocodeRepository,
		termsRepository: TermsRepository
	) {
		self.dogRepository = dogRepository
		self.userRepository = userRepository
		self.geocodeRepository = geocodeRepository
		self.termsRepository = termsRepository
	}
}

// MARK: - Dog UseCase
public extension OnBoardingUseCaseImpl {
	func createDogs(_ dog: Dog) -> Single<Void> {
		return dogRepository.createDog(dog)
	}
	
	func fetchDogCharacters() -> Single<[DogCharacter]> {
		return dogRepository.fetchDogCharacters()
	}
	
	func fetchDogSpecies() -> Single<[String]> {
		return dogRepository.fetchDogSpecies()
	}
}

// MARK: - User UseCase
public extension OnBoardingUseCaseImpl {
	func createUser(_ user: User) -> Single<Void> {
		return userRepository.createUser(user)
	}
	
	func checkDuplicated(nickName: String) -> Single<Void> {
		return userRepository.checkDuplicated(nickName: nickName)
	}
}

// MARK: - Address UseCase
public extension OnBoardingUseCaseImpl {
	func fetchGeocode(for address: String) -> Single<Location> {
		return geocodeRepository.fetchGeocode(for: address)
	}
}

// MARK: - Terms UseCase
public extension OnBoardingUseCaseImpl {
	func fetchTerms() -> Single<Terms> {
		return termsRepository.fetchTerms()
	}
}

// MARK: - OnBoaring Did Finish
public extension OnBoardingUseCaseImpl {
	func didFinish(
		user: User,
		dog: Dog,
		is마케팅정보수신동의Checked: Bool
	) -> Single<Void> {
		Observable.zip(
			createDogs(dog).asObservable(),
			createUser(user).asObservable()
		)
		.map { _, _ in }
		.asSingle()
	}
}
