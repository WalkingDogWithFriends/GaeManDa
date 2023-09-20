//
//  SignInUseCaseImpl.swift
//  UseCase
//
//  Created by jung on 2023/09/18.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import RxSwift
import Repository
import UseCase

public struct SignInUseCaseImpl: SignInUseCase {
	// MARK: - Properties
	public let dependency: SignInRepository
	
	// MARK: - Initializers
	public init(dependency: SignInRepository) {
		self.dependency = dependency
	}
	
	// MARK: - tryKakaoSignIn
	public func tryKakaoSignIn() -> Observable<Bool> {
		return dependency.tryKakaoSignIn()
	}
}
