//
//  DogRepositoryImpl.swift
//  DTO
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import RxSwift
import DTO
import Entity
import GMDNetwork
import Repository

public struct UserRepositoryImpl: UserRepository {
	public init() { }
	
	public func fetchUser(id: Int) async -> Single<User> {
		return  Provider<UserAPI>
			.init(stubBehavior: .immediate)
			.request(UserAPI.fetchUser(id: id), type: [UserResponseDTO].self)
			.map { $0.first! }
			.map { $0.toDomain }
	}
}
