//
//  TermsofUseUseCaseImpl.swift
//  Repository
//
//  Created by 김영균 on 11/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RxSwift
import Entity
import Repository
import UseCase

public struct TermsofUseUseCaseImpl: TermsofUseUseCase {
	private let repository: OnboardingRepository
	
	public init(repository: OnboardingRepository) {
		self.repository = repository
	}
	
	public func fetchTerms() -> Single<Terms> {
		return repository.fetchTerms()
	}
}
