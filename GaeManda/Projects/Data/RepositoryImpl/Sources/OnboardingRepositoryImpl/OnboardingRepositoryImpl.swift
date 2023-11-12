//
//  OnboardingRepositoryImpl.swift
//  LocalStorage
//
//  Created by 김영균 on 11/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import DTO
import Repository
import DataMapper
import Entity
import LocalStorage
import RxSwift

public struct OnboardingRepositoryImpl: OnboardingRepository {
	private let dataMapper: TermsMapper
	
	public init(dataMapper: TermsMapper) {
		self.dataMapper = dataMapper
	}
	
	public func fetchTerms() -> Single<Terms> {
		return Single.create { single in
			let result = FileProvider<OnboardingFileAPI>()
				.request(OnboardingFileAPI.fetchTerms, type: TermsResponseDTO.self)
				.map { dataMapper.mapToTerms(from: $0) }
			
			switch result {
			case .success(let terms): single(.success(terms))
			case .failure(let error): single(.failure(error))
			}
			
			return Disposables.create()
		}
	}
}
