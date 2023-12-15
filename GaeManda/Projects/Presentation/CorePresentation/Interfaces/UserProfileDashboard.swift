//
//  UserProfileDashboard.swift
//  CorePresentation
//
//  Created by jung on 12/14/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import RxRelay
import Entity

public enum NicknameTextFieldMode {
	/// default 모드
	case `default`
	/// 사용 가능한 닉네임
	case valid
	/// 닉네임 중복
	case duplicate
	/// 닉네임 미입력
	case notEntered
}

public protocol UserProfileDashboardBuildable: Buildable {
	func build(
		withListener listener: UserProfileDashboardListener,
		nicknameTextFieldMode: BehaviorRelay<NicknameTextFieldMode>,
		birthdayTextFieldIsWarning: BehaviorRelay<Bool>,
		userProfilePassingModel: UserProfilePassingModel?
	) -> ViewableRouting
}

public protocol UserProfileDashboardListener: AnyObject {
	func didSelectedGender(_ gender: Gender)
	func didEnteredUserName(_ name: String)
	func didSelectedBirthday(_ date: String)
}
