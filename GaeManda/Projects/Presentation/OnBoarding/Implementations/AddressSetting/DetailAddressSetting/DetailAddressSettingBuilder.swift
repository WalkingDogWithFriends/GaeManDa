//
//  DetailAddressSettingBuilder.swift
//  OnBoarding
//
//  Created by jung on 2023/07/08.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDUtils
import OnBoarding

public protocol DetailAddressSettingDependency: Dependency { }

final class DetailAddressSettingComponent: Component<DetailAddressSettingDependency> { }

public final class DetailAddressSettingBuilder:
	Builder<DetailAddressSettingDependency>,
	DetailAddressSettingBuildable {
	public override init(dependency: DetailAddressSettingDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: DetailAddressSettingListener) -> ViewableRouting {
		let viewController = DetailAddressSettingViewController()
		let interactor = DetailAddressSettingInteractor(presenter: viewController)
		interactor.listener = listener
		return DetailAddressSettingRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
