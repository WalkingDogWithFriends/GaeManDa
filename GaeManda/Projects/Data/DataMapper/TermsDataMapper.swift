//
//  TermsDataMapper.swift
//  LocalStorage
//
//  Created by 김영균 on 11/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Entity
import DTO

public protocol TermsDataMapper {
	func mapToTerms(from dto: TermsResponseDTO) -> Terms
}

public struct TermsDataMapperImpl: TermsDataMapper {
	public init() {}
	
	public func mapToTerms(from dto: TermsResponseDTO) -> Terms {
		return Terms(
			allAgreement: dto.allAgreement,
			useAgreement: dto.useAgreement,
			personalInformationAgreement: dto.personalInformationAgreement,
			locationAgreement: dto.locationAgreement,
			marketingAgreement: dto.marketingAgreement
		)
	}
}
