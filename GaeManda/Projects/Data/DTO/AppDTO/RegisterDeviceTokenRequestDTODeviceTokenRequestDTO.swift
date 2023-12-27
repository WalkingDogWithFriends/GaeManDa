//
//  RegisterDeviceTokenRequestDTO.swift
//  LocalStorage
//
//  Created by 김영균 on 12/17/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct RegisterDeviceTokenRequestDTO: Encodable {
	public let deviceToken: String
	
	public init(deviceToken: String) {
		self.deviceToken = deviceToken
	}
}
