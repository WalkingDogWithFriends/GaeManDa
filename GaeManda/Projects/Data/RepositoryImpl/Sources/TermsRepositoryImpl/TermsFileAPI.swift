//
//  TermsFileAPI.swift
//  LocalStorage
//
//  Created by 김영균 on 11/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import LocalStorage

public enum TermsFileAPI {
	case fetchTerms
}

extension TermsFileAPI: TargetType {
	public var filename: String {
		switch self {
		case .fetchTerms: return "Terms"
		}
	}
	
	public var task: TaskType {
		switch self {
		case .fetchTerms: return .read
		}
	}
	
	public var fileType: FileType {
		switch self {
		case .fetchTerms: return .json
		}
	}
}
