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

final class LoggedInComponent:
	Component<LoggedInDependency>,
	ChattingDependency,
	DogsOnAroundDependency,
	UserProfileDependency {
	lazy var chattingBuildable: ChattingBuildable = {
		return ChattingBuilder(dependency: self)
	}()
	
	lazy var dogsOnAroundBuildable: DogsOnAroundBuildable = {
		return DogsOnAroundBuilder(dependency: self)
	}()
	
	lazy var userProfileBuildable: UserProfileBuildable = {
		return UserProfileBuilder(dependency: self)
	}()
}
