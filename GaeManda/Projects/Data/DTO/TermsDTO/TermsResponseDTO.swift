//
//  TermsResponseDTO.swift
//  LocalStorage
//
//  Created by 김영균 on 11/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct TermsResponseDTO: Decodable {
	public let useAgreement: String
	public let personalInformationAgreement: String
	public let locationAgreement: String
	public let marketingAgreement: String
	
	enum CodingKeys: String, CodingKey {
		case useAgreement = "use_agreement"
		case personalInformationAgreement = "personal_information_agreement"
		case locationAgreement = "location_agreement"
		case marketingAgreement = "marketing_agreement"
	}
}
