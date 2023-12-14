//
//  DogRepositoryImpl.swift
//  DTO
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RxSwift
import DataMapper
import DTO
import Entity
import GMDNetwork
import Repository

public struct UserRepositoryImpl: UserRepository {
	private let dataMapper: UserDataMapper
	
	public init(dataMapper: UserDataMapper) {
		self.dataMapper = dataMapper
	}
	
	public func fetchUser() -> Single<User> {
		return  Provider<UserAPI>
			.init(stubBehavior: .immediate)
			.request(UserAPI.fetchUser, type: FetchUserResponseDTO.self)
			.map { dataMapper.mapToUser(from: $0) }
	}
	
	public func updateUser(_ user: User, isProfileImageChanged: Bool) -> Single<Void> {
		let requestDTO = dataMapper.mapToUpdateUserRequestDTO(from: user, isProfileImageChanged: isProfileImageChanged)
		
		return Provider<UserAPI>
			.init(stubBehavior: .immediate)
			.request(UserAPI.updateUser(requestDTO), type: VoidResponse.self)
			.map { _ in }
	}
	
	public func createUser(_ user: User) -> Single<Void> {
		let requestDTO = dataMapper.mapToCreateUserRequestDTO(from: user)
		
		return Provider<UserAPI>
			.init(stubBehavior: .immediate)
			.request(UserAPI.createUser(requestDTO), type: VoidResponse.self)
			.map { _ in }
	}
	
	public func checkDuplicated(nickName: String) -> Single<Void> {
		return Provider<UserAPI>
			.init(stubBehavior: .immediate)
			.request(UserAPI.checkDuplicated(nickName: nickName), type: VoidResponse.self)
			.map { _ in }
	}
}
