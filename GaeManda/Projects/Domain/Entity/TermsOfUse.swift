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
