//
//  LoggedInComponent.swift
//  GaeManda
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import Chatting
import ChattingImpl
import DogsOnAround
import DogsOnAroundImpl
import GMDProfile
import GMDProfileImpl
import Repository
import RepositoryImpl
import UseCase
import UseCaseImpl

final class LoggedInComponent:
	Component<LoggedInDependency>,
	ChattingListDependency,
	DogsOnAroundDependency,
	UserProfileDependency,
	UserProfileEditDependency,
	DogProfileEditDependency {	
	// MARK: Buildable
	lazy var chattingListBuildable: ChattingListBuildable = {
		return ChattingListBuilder(dependency: self)
	}()
	
	lazy var dogsOnAroundBuildable: DogsOnAroundBuildable = {
		return DogsOnAroundBuilder(dependency: self)
	}()
	
	lazy var userProfileBuildable: UserProfileBuildable = {
		return UserProfileBuilder(dependency: self)
	}()
	
	lazy var userProfileEditBuildable: UserProfileEditBuildable = {
		return UserProfileEditBuilder(dependency: self)
	}()
	
	lazy var dogProfileEditBuildable: DogProfileEditBuildable = {
		return DogProfileEditBuilder(dependency: self)
	}()
	
	// MARK: Repository
	lazy var dogRepository: DogRepository = {
		return DogRepositoryImpl()
	}()
	
	lazy var userRepository: UserRepository = {
		return UserRepositoryImpl()
	}()
	
	// MARK: UseCase
	lazy var userProfileUseCase: UserProfileUseCase = {
		return UserProfileUseCaseImpl(
			dogDependecy: dogRepository,
			userDependency: userRepository
		)
	}()
}
