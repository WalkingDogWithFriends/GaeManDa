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
		userRepository: UserRepository,
		geocodeRepository: GeocodeRepository,
		termsRepository: TermsRepository
	)
	
	func requestNotificationPermission() async throws -> Bool
	func requestLocationPermission()
	
	func createDogs(_ dog: Dog) -> Single<Void>
	func fetchDogCharacters() -> Single<[DogCharacter]>
	func fetchDogSpecies() -> Single<[String]>
	
	func createUser(_ user: User) -> Single<Void>
	func checkDuplicated(nickName: String) -> Single<Void>
	
	func fetchGeocode(for address: String) -> Single<Location>
	
	func fetchTerms() -> Single<Terms>
	
	func didFinish(
		user: User,
		dog: Dog,
		is마케팅정보수신동의Checked: Bool
	) -> Single<Void>
}
