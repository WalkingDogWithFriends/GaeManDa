//
//  AddressSettingPassingModel.swift
//  OnBoarding
//
//  Created by jung on 12/2/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct AddressPassingModel {
	public let latitude: Double
	public let longitude: Double

	public init(latitude: Double, longitude: Double) {
		self.latitude = latitude
		self.longitude = longitude
	}
	
	/// AddressSettingViewController의 default 카메라 포지션
	public static let `default` = AddressPassingModel(latitude: 37.5666102, longitude: 126.9783881)
}
