//
//  DetailAddressSetting.swift
//  OnBoarding
//
//  Created by jung on 2023/07/08.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

public protocol DetailAddressSettingBuildable: Buildable {
	func build(withListener listener: DetailAddressSettingListener) -> ViewableRouting
}

public protocol DetailAddressSettingListener: AnyObject {
	func detailAddressSettingDidDismiss()
	func detailAddressSettingCloseButtonDidTap()
	func detailAddressSettingLoadLocationButtonDidTap(latitude: Double, longitude: Double)
}
