//
//  SignInUseCaseImpl.swift
//  UseCase
//
//  Created by jung on 2023/09/18.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import Repository
import UseCase

public struct SignInUseCaseImpl {
	// MARK: - Properties
	private let signinRespository: SignInRepository
	
	// MARK: - Initializers
	public init(signinRespository: SignInRepository) {
		self.signinRespository = signinRespository
	}
}

extension SignInUseCaseImpl: SignInUseCase {
	public func kakaoLogin() async -> Bool {
		return await signinRespository.tryKakaoSignIn()
	}
	
	public func isOnboardingFinished() -> Bool {
		return signinRespository.isOnboardingFinished()
	}
	
	public func isAuthorized() -> Bool {
		return signinRespository.isAuthorized()
	}
}
