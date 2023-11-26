//
//  Gender.swift
//  Entity
//
//  Created by jung on 11/26/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

public enum Gender: String {
	case male = "M"
	case female = "F"
	
	public var genderKR: String {
		switch self {
			case .male: "남"
			case .female: "여"
		}
	}
}
