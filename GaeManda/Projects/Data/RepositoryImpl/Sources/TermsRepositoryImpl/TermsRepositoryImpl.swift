//
//  TermsRepositoryImpl.swift
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

public struct TermsRepositoryImpl: TermsRepository {
	private let dataMapper: TermsDataMapper
	
	public init(dataMapper: TermsDataMapper) {
		self.dataMapper = dataMapper
	}
	
	public func fetchTerms() -> Single<Terms> {
		return Single.create { single in
			let result = FileProvider<TermsFileAPI>()
				.request(TermsFileAPI.fetchTerms, type: TermsResponseDTO.self)
				.map { dataMapper.mapToTerms(from: $0) }
			
			switch result {
			case .success(let terms): single(.success(terms))
			case .failure(let error): single(.failure(error))
			}
			
			return Disposables.create()
		}
	}
}
