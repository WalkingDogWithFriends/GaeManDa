//
//  DogReposiotry.swift
//  Repository
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import RxSwift
import Entity

public protocol DogRepository {
	func fetchDogs() -> Single<[Dog]>
	func updateDog(_ dog: Dog, isProfileImageChanged: Bool) -> Single<Void>
	func createDog(_ dog: Dog) -> Single<Void>
	func fetchDogCharacters() -> Single<[DogCharacter]>
	func fetchDogSpecies() -> Single<[String]>
}
