//
//  DogReqestDTO.swift
//  DTO
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct DogRequestDTO: Encodable {
	public let petId: Int
	
	public init(petId: Int) {
		self.petId = petId
	}
}
