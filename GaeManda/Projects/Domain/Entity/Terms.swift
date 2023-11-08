//
//  Terms.swift
//  Repository
//
//  Created by 김영균 on 11/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct Terms {
	public let allAgreement: String
	public let useAgreement: String
	public let personalInformationAgreement: String
	public let locationAgreement: String
	public let marketingAgreement: String
	
	public init(
		allAgreement: String,
		useAgreement: String,
		personalInformationAgreement: String,
		locationAgreement: String,
		marketingAgreement: String
	) {
		self.allAgreement = allAgreement
		self.useAgreement = useAgreement
		self.personalInformationAgreement = personalInformationAgreement
		self.locationAgreement = locationAgreement
		self.marketingAgreement = marketingAgreement
	}
}
