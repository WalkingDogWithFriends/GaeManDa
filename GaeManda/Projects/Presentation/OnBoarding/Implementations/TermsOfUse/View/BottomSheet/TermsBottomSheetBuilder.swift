//
//  TermsBottomSheetBuilder.swift
//  OnBoarding
//
//  Created by 김영균 on 11/2/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import OnBoarding

final class TermsBottomSheetComponent: Component<TermsBottomSheetDependency> {
	let type: BottomSheetType
	let terms: String
	
	init(
		dependency: TermsBottomSheetDependency,
		type: BottomSheetType,
		terms: String
	) {
		self.type = type
		self.terms = terms
		super.init(dependency: dependency)
	}
}

// MARK: - Builder
public final class TermsBottomSheetBuilder: Builder<TermsBottomSheetDependency>, TermsBottomSheetBuildable {
	public override init(dependency: TermsBottomSheetDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(
		withListener listener: TermsBottomSheetListener,
		type: BottomSheetType,
		terms: String
	) -> ViewableRouting {
		let component = TermsBottomSheetComponent(
			dependency: dependency,
			type: type,
			terms: terms
		)
		let viewController = TermsBottomSheetViewController()
		let interactor = TermsBottomSheetInteractor(
			presenter: viewController,
			type: component.type,
			terms: component.terms
		)
		interactor.listener = listener
		return TermsBottomSheetRouter(interactor: interactor, viewController: viewController)
	}
}
