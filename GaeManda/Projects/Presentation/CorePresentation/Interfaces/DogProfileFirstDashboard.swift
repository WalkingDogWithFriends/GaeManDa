//
//  DogProfileFirstDashboard.swift
//  CorePresentation
//
//  Created by jung on 12/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import RxRelay
import Entity

public protocol DogProfileFirstDashboardBuildable: Buildable {
	func build(
		withListener listener: DogProfileFirstDashboardListener,
		nameTextFieldIsWarning: BehaviorRelay<Void>,
		birthdayTextFieldIsWarning: BehaviorRelay<Void>,
		weightTextFieldIsWarning: BehaviorRelay<Void>,
		passingModel: DogProfileFirstPassingModel?
	) -> ViewableRouting
}

public protocol DogProfileFirstDashboardListener: AnyObject { 
	func didSelectedGender(_ gender: Gender)
	func didSelectedBirthday(_ date: String)
	func didEnteredDogName(_ name: String)
	/// 잘못된 형식이거나, 입력안 한 경우 -1 전달합니다.
	func didEnteredDogWeight(_ weight: Int)
}
