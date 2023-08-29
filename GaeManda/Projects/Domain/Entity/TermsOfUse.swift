//
//  TermsOfUse.swift
//  Entity
//
//  Created by jung on 2023/07/08.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct TermsOfUse {
	public let title: String
	public let isRequired: Bool
	public let subTitle: String?
	public let webURL: String = "www.google.com"
}

public extension TermsOfUse {
	init(title: String, isRequired: Bool) {
		self.title = title
		self.isRequired = isRequired
		self.subTitle = nil
	}
	
	init(title: String, isRequired: Bool, subTitle: String) {
		self.title = title
		self.isRequired = isRequired
		self.subTitle = subTitle
	}
}

public extension TermsOfUse {
	static let data = [
		TermsOfUse(
			title: "이용약관 동의",
			isRequired: true
		),
		TermsOfUse(
			title: "개인정보 수집 및 이용 동의",
			isRequired: true
		),
		TermsOfUse(
			title: "위치정보 수집 및 이용 동의",
			isRequired: true
		),
		TermsOfUse(
			title: "마케팅 정보 수신 동의",
			isRequired: false,
			subTitle: "다양한 소식 및 프로모션 정보를 보내 드립니다."
		)
	]
}
