//
//  UserRequestDTO.swift
//  DTO
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct UserRequestDTO: Encodable {
	public let id: Int
	
	public init(id: Int) {
		self.id = id
	}
}
