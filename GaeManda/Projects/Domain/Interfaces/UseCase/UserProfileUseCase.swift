//
//  ProfileUseCase.swift
//  UseCase
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import RxSwift
import Entity
import Repository

public protocol UserProfileUseCase {
	var dogDependency: DogRepository { get }
	var userDependency: UserRepository { get }

	init(
		dogDependecy: DogRepository,
		userDependency: UserRepository
	)
	
	func fetchDogs(id: Int) -> Single<[Dog]>
	func fetchUser(id: Int) -> Single<User>
	func updateUser(
		nickName: String,
		age: Int,
		sex: String
	) -> Single<String>
}
