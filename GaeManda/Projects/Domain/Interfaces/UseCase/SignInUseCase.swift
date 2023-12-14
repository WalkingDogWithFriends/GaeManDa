//
//  SignInUseCase.swift
//  UseCase
//
//  Created by jung on 2023/09/18.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

public protocol SignInUseCase {
	func kakaoLogin() async -> Bool
	func isOnboardingFinished() -> Bool
	func isAuthorized() -> Bool
}
