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
	
	init(dogDependecy: DogRepository)
	
	func fetchDogs(id: Int) async -> Single<[Dog]>
}
