//
//  BirthdayPicker.swift
//  DesignKit
//
//  Created by 김영균 on 9/23/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

public protocol BirthdayPickerBuildable: Buildable {
	func build(withListener listener: BirthdayPickerListener) -> ViewableRouting
}

public protocol BirthdayPickerListener: AnyObject {
	func birthdayPickerDismiss()
	func birthdaySelected(date: String)
}
