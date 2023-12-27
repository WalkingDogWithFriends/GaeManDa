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
import CorePresentation
import DataMapper
import GMDUtils
import GMDMap
import GMDMapImpl
import GMDProfile
import GMDProfileImpl
import Repository
import RepositoryImpl
import UseCase
import UseCaseImpl

final class LoggedInComponent:
	Component<LoggedInDependency>,
	ChattingListDependency,
	ChattingDependency,
	GMDMapDependency,
	GMDProfileDependency,
	UserProfileEditDependency,
	DogProfileEditDependency,
	NewDogProfileDependency {
	// MARK: CLLocation Managable
	var locationManagable: CLLocationManagable { dependency.locationManagable}
	
	// MARK: - Buildable
	lazy var chattingListBuildable: ChattingListBuildable = {
		return ChattingListBuilder(dependency: self)
	}()
	
	lazy var chattingBuildable: ChattingBuildable = {
		return ChattingBuilder(dependency: self)
	}()
	
	lazy var gmdMapBuildable: GMDMapBuildable = {
		return GMDMapBuilder(dependency: self)
	}()
	
	lazy var gmdProfileBuildable: GMDProfileBuildable = {
		return GMDProfileBuilder(dependency: self)
	}()
	
	lazy var userProfileEditBuildable: UserProfileEditBuildable = {
		return UserProfileEditBuilder(dependency: self)
	}()
	
	lazy var dogProfileEditBuildable: DogProfileEditBuildable = {
		return DogProfileEditBuilder(dependency: self)
	}()
	
	lazy var newDogProfileBuildable: NewDogProfileBuildable = {
		return NewDogProfileBuilder(dependency: self)
	}()
	
	var gmdProfileUseCase: GMDProfileUseCase {
		dependency.gmdProfileUseCase
	}
	
	var userProfileDashboardBuildable: UserProfileDashboardBuildable {
		dependency.userProfileDashboardBuildable
	}
}
