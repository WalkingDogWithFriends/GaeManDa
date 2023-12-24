//
//  TermsBottomSheetBuilder.swift
//  OnBoarding
//
//  Created by 김영균 on 11/2/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import OnBoarding

final class TermsBottomSheetComponent: Component<TermsBottomSheetDependency> {}

// MARK: - Builder
public final class TermsBottomSheetBuilder: Builder<TermsBottomSheetDependency>, TermsBottomSheetBuildable {
	public override init(dependency: TermsBottomSheetDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(
		withListener listener: TermsBottomSheetListener,
		type: TermsType,
		terms: String?
	) -> ViewableRouting {
		let viewController = TermsBottomSheetViewController()
		let interactor = TermsBottomSheetInteractor(
			presenter: viewController,
			type: type,
			terms: terms
		)
		interactor.listener = listener
		return TermsBottomSheetRouter(interactor: interactor, viewController: viewController)
	}
}
