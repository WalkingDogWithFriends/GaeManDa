//
//  TermsBottomSheet.swift
//  OnBoarding
//
//  Created by 김영균 on 11/2/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

public enum BottomSheetType {
	case a약관전체동의
	case a이용약관동의
	case a개인정보수집및이용동의
	case a위치정보수집및이용동의
	case a마케팅정보수신동의
}

public protocol TermsBottomSheetDependency: Dependency {}

public protocol TermsBottomSheetBuildable: Buildable {
	func build(
		withListener listener: TermsBottomSheetListener,
		type: BottomSheetType,
		terms: String?
	) -> ViewableRouting
}

public protocol TermsBottomSheetListener: AnyObject {
	func termsBottomSheetDismiss()
	func termsBottomSheetDidFinish(type: BottomSheetType)
}
