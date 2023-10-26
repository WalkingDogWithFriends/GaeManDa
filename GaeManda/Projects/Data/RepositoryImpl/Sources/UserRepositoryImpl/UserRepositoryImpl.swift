//
//  DogRepositoryImpl.swift
//  DTO
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import RxSwift
import DataMapper
import DTO
import Entity
import GMDNetwork
import Repository

public struct UserRepositoryImpl: UserRepository {
	private let userDataMapper: UserDataMapper
	
	public init(userDataMapper: UserDataMapper) {
		self.userDataMapper = userDataMapper
	}
	
	public func fetchUser(id: Int) -> Single<User> {
		return  Provider<UserAPI>
			.init(stubBehavior: .immediate)
			.request(UserAPI.fetchUser(id: id), type: UserProfileResponseDTO.self)
			.map { userDataMapper.mapToUser(from: $0) }
	}
	
	public func updateUser(
		nickName: String,
		age: Int,
		sex: String
	) -> Single<Void> {
		return Provider<UserAPI>
			.init(stubBehavior: .immediate)
			.request(UserAPI.updateUser(nickName, age, sex), type: VoidResponse.self)
			.map { _ in }
	}
}
