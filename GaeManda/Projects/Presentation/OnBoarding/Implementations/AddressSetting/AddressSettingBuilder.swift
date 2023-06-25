//
//  AddressSettingBuilder.swift
//  OnBoardingImpl
//
//  Created by jung on 2023/06/25.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import OnBoarding

public protocol AddressSettingDependency: Dependency { }

final class AddressSettingComponent: Component<AddressSettingDependency> { }

public final class AddressSettingBuilder:
	Builder<AddressSettingDependency>,
	AddressSettingBuildable {
	public override init(dependency: AddressSettingDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: AddressSettingListener) -> ViewableRouting {
		let viewController = AddressSettingViewController()
		let interactor = AddressSettingInteractor(presenter: viewController)
		interactor.listener = listener
		return AddressSettingRouter(interactor: interactor, viewController: viewController)
	}
}
