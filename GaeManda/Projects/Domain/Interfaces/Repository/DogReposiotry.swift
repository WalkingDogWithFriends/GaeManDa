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
	func fetchDogs(id: Int) -> Single<[Dog]>
	func updateDog(dog: Dog) -> Single<String>
	func postNewDog(dog: Dog) -> Single<String>
}
